SRC_URI:append = " file://defconfig"
KBUILD_DEFCONFIG = ""

# Build the CompuLab baseline first, then apply the shared additions/removals
# and finally the i.MX93-specific pruning policy kept in the kernel tree.
do_configure:append() {
    oe_runmake -C ${S} O=${B} compulab_v8_defconfig
    ${S}/scripts/kconfig/merge_config.sh -m -O ${B} \
        ${B}/.config \
        ${S}/arch/arm64/configs/compulab_add.config \
        ${S}/arch/arm64/configs/compulab_rem.config \
        ${S}/arch/arm64/configs/cl-imx93-prune.cfg
    oe_runmake -C ${S} O=${B} olddefconfig
}
