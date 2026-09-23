SRC_URI:append = " file://defconfig"
KBUILD_DEFCONFIG = ""
CL_IMX93_CONFIG_FRAGMENTS = ""
CL_IMX93_CONFIG_FRAGMENTS:iot-link = "${S}/arch/arm64/configs/cl-imx93-rt.cfg"
LOCALVERSION:append:iot-link = "-rt"

# Build the CompuLab baseline first, then apply the shared additions/removals
# the i.MX93 pruning policy, and the optional machine-specific RT policy.
do_configure:append() {
    oe_runmake -C ${S} O=${B} compulab_v8_defconfig
    ${S}/scripts/kconfig/merge_config.sh -m -O ${B} \
        ${B}/.config \
        ${S}/arch/arm64/configs/compulab_add.config \
        ${S}/arch/arm64/configs/compulab_rem.config \
        ${S}/arch/arm64/configs/cl-imx93-prune.cfg \
        ${CL_IMX93_CONFIG_FRAGMENTS}
    oe_runmake -C ${S} O=${B} olddefconfig
    if [ "${MACHINE}" = "iot-link" ]; then
        if ! grep -q '^CONFIG_PREEMPT_RT=y$' ${B}/.config; then
            bbfatal "IOT-LINK requires CONFIG_PREEMPT_RT=y"
        fi
        if grep -q '^CONFIG_RT_GROUP_SCHED=y$' ${B}/.config; then
            bbfatal "IOT-LINK RT policy requires RT_GROUP_SCHED disabled"
        fi
    fi
}
