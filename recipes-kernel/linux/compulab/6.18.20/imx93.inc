LOCALVERSION:append:iot-link = "-rt"

# Configuration fragments already present in the kernel source tree.
KERNEL_FEATURES:append = " compulab_add.config "
KERNEL_FEATURES:append = " compulab_rem.config "
KERNEL_FEATURES:append = " cl-imx93-prune.cfg "
KERNEL_FEATURES:append = " cl-imx93-rt.cfg "
KERNEL_FEATURES:append = "${@bb.utils.contains('DISTRO_FEATURES', 'yebian', ' nxp-wlan.config ', '', d)}"

do_configure:append() {
    if [ "${MACHINE}" = "iot-link" ]; then
        if ! grep -q '^CONFIG_PREEMPT_RT=y$' ${B}/.config; then
            bbfatal "IOT-LINK requires CONFIG_PREEMPT_RT=y"
        fi
        if grep -q '^CONFIG_RT_GROUP_SCHED=y$' ${B}/.config; then
            bbfatal "IOT-LINK RT policy requires RT_GROUP_SCHED disabled"
        fi
    fi
}
