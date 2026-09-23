#!/bin/bash
# Run on the golden target. USB preparation ERASES the selected USB disk.
set -euo pipefail
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
USB=""
DRY_RUN=0
while (( $# )); do
    case "$1" in
        --usb) USB=${2:?--usb requires /dev/device}; shift 2 ;;
        --dry-run) DRY_RUN=1; shift ;;
        *) echo "Usage: $0 [--usb /dev/sda] [--dry-run]" >&2; exit 2 ;;
    esac
done
fail() { echo "ERROR: $*" >&2; exit 1; }
[[ $EUID == 0 ]] || fail "Run as root."
for tool in lsblk findmnt readlink blockdev du sfdisk dd losetup mount umount mkfs.ext4 sha256sum e2fsck rsync udevadm mountpoint tac; do
    command -v "$tool" >/dev/null || fail "Missing tool: $tool"
done
command -v cl-deploy >/dev/null || fail "cl-deploy is not installed."

ROOT_SOURCE=$(findmnt -no SOURCE /)
ROOT_PARENT=$(lsblk -no PKNAME "$ROOT_SOURCE")
SOURCE=/dev/$ROOT_PARENT
[[ -b $SOURCE && $ROOT_PARENT =~ ^mmcblk[0-9]+$ ]] || fail "Root must be a partition on eMMC: $ROOT_SOURCE"
[[ $(cat /sys/class/block/$ROOT_PARENT/device/type) == MMC ]] || fail "Root storage is not eMMC."
ROOT_NUMBER=$(cat /sys/class/block/$(basename "$ROOT_SOURCE")/partition)
mapfile -t PARTS < <(lsblk -lpo NAME,TYPE "$SOURCE" | awk '$2 == "part" {print $1}')
[[ ${#PARTS[@]} == 2 && $ROOT_NUMBER == 2 ]] || fail "Expected boot partition 1 followed by root partition 2."
BOOT_SOURCE=${PARTS[0]}

mapfile -t USB_DISKS < <(lsblk -dnpo NAME,TYPE,TRAN | awk '$2 == "disk" && $3 == "usb" {print $1}')
if [[ -z $USB ]]; then
    [[ ${#USB_DISKS[@]} == 1 ]] || fail "Connect exactly one USB disk, or specify --usb /dev/device."
    USB=${USB_DISKS[0]}
fi
[[ -z $(lsblk -nrpo MOUNTPOINTS "$USB" | tr -d '[:space:]') ]] || fail "Unmount all partitions on $USB first."
for dev in $(lsblk -nrpo NAME "$USB"); do
    [[ -z $(ls /sys/class/block/$(basename "$dev")/holders) ]] || fail "$dev has an active device-mapper holder."
done

# Binary storage units: one mebibyte (MiB) is 1024 * 1024 bytes.
BYTES_PER_MIB=$((1024 * 1024))
PERCENT_SCALE=100
ROOT_FREE_SPACE_PERCENT=20
EXT4_RESERVED_PERCENT=5 # default reserved space, unavailable to normal users.
ROOT_METADATA_ALLOWANCE_MIB=128 # Budget for ext4 metadata and copy-time growth.
IMAGE_END_ALLOWANCE_MIB=2 # Budget for end-of-disk alignment and backup GPT.
USB_FILESYSTEM_ALLOWANCE_MIB=512 # Carrier filesystem metadata, logs and checksum files.
GPT_PREFIX_SECTORS=34 # Protective MBR, primary GPT header and partition entries.

# Integer division rounded upward so allocations never lose a partial unit.
ceil_div() { echo $(( ($1 + $2 - 1) / $2 )); }

ROOT_USED=$(du -sx -B1 / | awk '{print $1}')
SECTOR_SIZE=$(blockdev --getss "$SOURCE")
ROOT_START=$(cat /sys/class/block/$(basename "$ROOT_SOURCE")/start)
BOOT_START=$(cat /sys/class/block/$(basename "$BOOT_SOURCE")/start)
(( SECTOR_SIZE == 512 && BOOT_START > GPT_PREFIX_SECTORS )) || fail "Unsupported bootloader prefix geometry."
# Everything before rootfs includes the boot partition and its original offsets.
PREFIX_BYTES=$((ROOT_START * SECTOR_SIZE))
REQUIRED_ROOT_FREE_BYTES=$(ceil_div "$((ROOT_USED * ROOT_FREE_SPACE_PERCENT))" "$PERCENT_SCALE")
ROOT_PAYLOAD_BYTES=$((ROOT_USED + REQUIRED_ROOT_FREE_BYTES + ROOT_METADATA_ALLOWANCE_MIB * BYTES_PER_MIB))
# Only 95% of the ext4 partition is usable after its default 5% reserve.
ROOT_PARTITION_BYTES=$(ceil_div "$((ROOT_PAYLOAD_BYTES * PERCENT_SCALE))" "$((PERCENT_SCALE - EXT4_RESERVED_PERCENT))")
IMAGE_BYTES=$((PREFIX_BYTES + ROOT_PARTITION_BYTES + IMAGE_END_ALLOWANCE_MIB * BYTES_PER_MIB))
IMAGE_MIB=$(ceil_div "$IMAGE_BYTES" "$BYTES_PER_MIB")
USB_BYTES=$(blockdev --getsize64 "$USB")
REQUIRED_USB_BYTES=$(((IMAGE_MIB + USB_FILESYSTEM_ALLOWANCE_MIB) * BYTES_PER_MIB))
(( USB_BYTES > REQUIRED_USB_BYTES )) || fail "USB needs room for the image plus $USB_FILESYSTEM_ALLOWANCE_MIB MiB filesystem overhead."

echo "eMMC source: $SOURCE (root: $ROOT_SOURCE, boot: $BOOT_SOURCE)"
lsblk -d -o NAME,SIZE,MODEL,SERIAL,TRAN "$USB"
echo "USB TO ERASE: $USB"
echo "Used rootfs: $ROOT_USED bytes"
echo "Zero-filled image: $IMAGE_MIB MiB"
echo "USB filesystem: ext4; image: /mnt/golden-usb/$(hostname)-emmc-golden.img"
(( ! DRY_RUN )) || exit 0
read -r -p "Type Y to format this USB: " ANSWER
[[ $ANSWER == "Y" ]] || fail "USB preparation cancelled."

USB_MOUNT=/mnt/golden-usb
mkdir -p "$USB_MOUNT"
! mountpoint -q "$USB_MOUNT" || fail "$USB_MOUNT is already mounted."
WORK=$(mktemp -d /run/golden-capture.XXXXXX)
LOOP=""
USB_MOUNTED=0
cleanup() {
    for dir in root; do
        mountpoint -q "$WORK/$dir" && umount "$WORK/$dir" || true
    done
    if [[ -n $LOOP ]]; then
        while IFS= read -r target; do
            [[ -z $target ]] || umount "$target" || true
        done < <(lsblk -nrpo MOUNTPOINTS "$LOOP" | tac)
        losetup --detach "$LOOP" || true
    fi
    if (( USB_MOUNTED )); then sync; umount "$USB_MOUNT" || true; fi
    rmdir "$WORK/root" "$WORK" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

printf 'label: gpt\nstart=2048, type=L\n' | sfdisk --wipe always --wipe-partitions always "$USB"
udevadm settle
USB_PART=${USB}1
[[ -b $USB_PART ]] || fail "USB partition not available: $USB_PART"
mkfs.ext4 -F -m 0 -L GOLDEN_USB "$USB_PART"
mount "$USB_PART" "$USB_MOUNT"
USB_MOUNTED=1
OUT=$USB_MOUNT/$(hostname)-emmc-golden.img
sfdisk --dump "$SOURCE" > "$OUT.source.sfdisk"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS "$SOURCE" > "$OUT.source.txt"
cp /proc/cmdline "$OUT.cmdline.txt"
df -B1 / > "$OUT.source-df.txt"

dd if=/dev/zero of="$OUT" bs=1M count="$IMAGE_MIB" conv=fsync status=progress
LOOP=$(losetup --find --show --partscan "$OUT")
sync
# The selected USB holds the image file; cl-deploy writes only the loop device.
echo "Deploying $SOURCE to $LOOP; log: $OUT.deploy.log"
SRC="$SOURCE" DST="$LOOP" QUIET=Yes cl-deploy > "$OUT.deploy.log" 2>&1
echo "generating checksum..."
LOOP=""
(cd "$USB_MOUNT" && sha256sum "$(basename "$OUT")" > "$(basename "$OUT").sha256")
echo "Created $OUT with checksum and validation records."
