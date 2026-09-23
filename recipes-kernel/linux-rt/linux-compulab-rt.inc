FILESEXTRAPATHS:prepend := "${THISDIR}/compulab/${PV}:"

# PREEMPT_RT is integrated in Linux 6.18. IOT-LINK selects its in-tree
# fragment in imx93.inc, independent of the distro-wide linux-rt feature.
CL_IMX93_CONFIG_FRAGMENTS:append = "${@bb.utils.contains('DISTRO_FEATURES', 'linux-rt', ' ${S}/arch/arm64/configs/cl-imx93-rt.cfg', '', d)}"
