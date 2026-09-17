# Create a golden image
The script copies the eMMC fs to a USB storage as an image file.
To make USB itself an OS disk, use the cl-deploy command
The image covers eMMC user-area partitions. Hardware boot areas (`mmcblk0boot0`/`boot1`) are outside this file

## Requirements
- A target booted from the golden eMMC, with the OS, BSP and customer software
- A USB drive whose contents can be erased.
- Stop customer applications, database services and other writers before capture

## Run on the target
Copy the script capture-emmc-golden-image.sh to /tmp/ , then run:
```sh
chmod +x /tmp/capture-emmc-golden-image.sh
/tmp/capture-emmc-golden-image.sh
```

To select a USB explicitly:
```sh
/tmp/capture-emmc-golden-image.sh --usb /dev/sda
```

## Handoff
Optionally compress the image after reconnecting/mounting the USB:
```sh
cd /path/to/mounted/USB
gzip -k iot-link-emmc-golden.img
sha256sum iot-link-emmc-golden.img.gz > iot-link-emmc-golden.img.gz.sha256
```

The receiver will verify the supplied checksum after transfer.
