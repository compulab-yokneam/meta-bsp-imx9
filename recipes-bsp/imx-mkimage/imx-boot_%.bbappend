DEPENDS:remove = "linux-imx u-boot-imx"
DEPENDS:append = " u-boot-compulab "
DEPENDS:append = " ${@bb.utils.contains('SECURE_BOOT', '1', 'linux-compulab', '', d)} "

IMX_BOOT_SECU_UBOOT ??= "u-boot-compulab"
IMX_BOOT_SECU_KERNEL ??= "linux-compulab"

do_compile:prepend() {
    export KERNEL_DTB="${KERNEL_DEVICETREE_BASENAME}.dtb"
}

do_install[depends] += "${PN}:do_deploy"

do_install:append() {
    # Setscene restores shared deploy files, not the private DEPLOYDIR.
    install -m 0644 ${DEPLOY_DIR_IMAGE}/imx-boot.tagged ${D}/boot/
    install -m 0644 ${DEPLOY_DIR_IMAGE}/imx-boot ${D}/boot/imx-boot
}
