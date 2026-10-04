KBUILD_DEFCONFIG = "compulab_v8_defconfig"

# Keep the CompuLab policy at the beginning of kernel-yocto's configuration
# queue.  Fragments appended to SRC_URI by a downstream bbappend are then
# merged afterwards and can extend the configuration for customer hardware.
CL_IMX93_RT_CONFIG_FEATURE = "${@bb.utils.contains('DISTRO_FEATURES', 'linux-rt', ' file://cl-imx93-rt.scc', '', d)}"
CL_IMX93_RT_CONFIG_FEATURE:cl-imx93 = ""
CL_IMX93_RT_CONFIG_FEATURE:iot-link = " file://cl-imx93-rt.scc"
CL_IMX93_CONFIG_FEATURES = "file://cl-imx93.scc${CL_IMX93_RT_CONFIG_FEATURE}"
SRC_URI:prepend = "${CL_IMX93_CONFIG_FEATURES} "

# This fragment is supplied by the kernel tree and is needed only by Yebian.
KERNEL_FEATURES:append = "${@bb.utils.contains('DISTRO_FEATURES', 'yebian', ' nxp-wlan.config ', '', d)}"

LOCALVERSION:append:iot-link = "-rt"

do_configure:append:iot-link() {
    if [ "${MACHINE}" = "iot-link" ]; then
        if ! grep -q '^CONFIG_PREEMPT_RT=y$' ${B}/.config; then
            bbfatal "IOT-LINK requires CONFIG_PREEMPT_RT=y"
        fi
        if grep -q '^CONFIG_RT_GROUP_SCHED=y$' ${B}/.config; then
            bbfatal "IOT-LINK RT policy requires RT_GROUP_SCHED disabled"
        fi
    fi
}
