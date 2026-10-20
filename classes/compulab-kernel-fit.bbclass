# Build FIT images with the CompuLab kernel's own generator. Yocto still owns
# package creation and WIC deployment; make bindeb-pkg is not used here.
inherit python3native

DEPENDS += "u-boot-tools-native dtc-native"

# Consume the in-tree platform settings instead of copying DTs and addresses.
# Customer KERNEL_FEATURES appended later may override these defaults.
KERNEL_FEATURES:prepend = "fitimage-imx93.config "

PACKAGES =+ "${KERNEL_PACKAGE_NAME}-fitimage"
FILES:${KERNEL_PACKAGE_NAME}-fitimage = "/${KERNEL_IMAGEDEST}/fitImage"
RREPLACES:${KERNEL_PACKAGE_NAME}-fitimage = "linux-yocto-fitimage"
RCONFLICTS:${KERNEL_PACKAGE_NAME}-fitimage = "linux-yocto-fitimage"

# Keep KERNEL_IMAGETYPE=Image: OE reserves fitImage for its separate generator.
do_compile:append() {
    oe_runmake fitImage FIT_MKIMAGE="${STAGING_BINDIR_NATIVE}/mkimage"
}

do_install:append() {
    install -Dm0644 ${B}/arch/${ARCH}/boot/fitImage ${D}/${KERNEL_IMAGEDEST}/fitImage
}

kernel_do_deploy:append() {
    install -m 0644 ${B}/arch/${ARCH}/boot/fitImage $deployDir/fitImage
    install -m 0644 ${B}/arch/${ARCH}/boot/fit-image.its $deployDir/fit-image.its
}
