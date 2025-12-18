DEPENDS:remove = "linux-imx u-boot-imx"
DEPENDS:append = " linux-compulab u-boot-compulab"

IMX_BOOT_SECU_UBOOT ??= "u-boot-compulab"
IMX_BOOT_SECU_KERNEL ??= "linux-compulab"

do_compile:prepend() {
    export KERNEL_DTB="${KERNEL_DEVICETREE_BASENAME}.dtb"
}
