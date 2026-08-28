FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://0001-drivers-net-phy-configure-LED1-for-RTL8211F-to-enabl.patch \
    file://0002-cl-imx93-Fix-the-ethphy1-reset-gpio.patch \
    file://0003-board-compulab-ucm-imx93-configure-EQOS-PHY-at-boot.patch \
"
