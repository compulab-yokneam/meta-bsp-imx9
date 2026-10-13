SUMMARY = "Update the CompuLab i.MX93 eMMC bootloader before booting Linux"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://boot.script"
S = "${UNPACKDIR}"

DEPENDS = "u-boot-mkimage-native"
do_compile[depends] += "imx-boot:do_deploy"

inherit deploy

python do_compile() {
    import binascii
    import pathlib
    import struct
    import subprocess

    image = pathlib.Path(d.getVar("DEPLOY_DIR_IMAGE")) / "imx-boot"
    data = image.read_bytes()
    # U-Boot stores its environment at offset 0x300000 in eMMC boot0.
    if not data or len(data) > 0x300000:
        bb.fatal("imx-boot does not fit before the eMMC boot0 environment")

    source = pathlib.Path(d.getVar("UNPACKDIR")) / "boot.script"
    output = pathlib.Path(d.getVar("B"))
    output.mkdir(parents=True, exist_ok=True)
    script = source.read_text()
    boards = {
        "ucm-imx93": [("ucm-imx93.dtb", "ucm-imx93")],
        "mcm-imx93": [("sbc-mcm-imx93.dtb", "mcm-imx93")],
        "iot-link": [("iot-link.dtb", "iot-link")],
        "cl-imx93": [
            ("ucm-imx93.dtb", "ucm-imx93"),
            ("sbc-mcm-imx93.dtb", "mcm-imx93"),
        ],
    }
    machine = d.getVar("MACHINE")
    if machine not in boards:
        bb.fatal(f"No bootloader update board guard defined for {machine}")
    guard = []
    for fdt, platform in boards[machine]:
        guard.append(f'if test "${{fdtfile}}" = {fdt}; then setenv cl_update_board yes; fi')
        guard.append(f'if test "${{platform_detected}}" = {platform}; then setenv cl_update_board yes; fi')
    script = script.replace("@BOARD_GUARD@", "\n".join(guard))
    script = script.replace("@IMAGE_SIZE@", f"0x{len(data):x}")
    script = script.replace("@IMAGE_BLOCKS@", f"0x{(len(data) + 511) // 512:x}")
    image_crc = binascii.crc32(data) & 0xffffffff
    script = script.replace("@IMAGE_CRC32@", f"{image_crc:08x}")
    script = script.replace("@MARKER_CRC32@", f"{binascii.crc32(struct.pack('<I', image_crc)) & 0xffffffff:08x}")
    text = output / "boot.script"
    text.write_text(script)

    mkimage = pathlib.Path(d.getVar("STAGING_BINDIR_NATIVE")) / "mkimage"
    subprocess.run([str(mkimage), "-A", "arm", "-T", "script", "-C", "none",
                    "-n", "CompuLab i.MX93 bootloader update", "-d", str(text),
                    str(output / "boot.scr")], check=True)
}

do_deploy() {
    install -Dm0644 ${B}/boot.scr ${DEPLOYDIR}/boot.scr
}

do_install() {
    install -Dm0644 ${B}/boot.scr ${D}/boot/boot.scr
}

addtask deploy after do_compile before do_build

FILES:${PN} = "/boot/boot.scr"
PACKAGE_ARCH = "${MACHINE_ARCH}"
