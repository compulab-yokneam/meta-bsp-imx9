FILESEXTRAPATHS:prepend := "${THISDIR}:"

SRC_URI:append = "${@bb.utils.contains('DISTRO_FEATURES', 'yebian', ' file://nxp-wlan.cfg ', '', d)}"
