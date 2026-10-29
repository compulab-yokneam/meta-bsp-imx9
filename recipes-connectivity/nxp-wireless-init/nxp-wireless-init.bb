SUMMARY = "Initialize IOT-LINK Bluetooth after WLAN combo firmware is ready"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://nxp-wireless-init file://nxp-wireless-init.service file://btnxpuart.conf"
S = "${UNPACKDIR}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "nxp-wireless-init.service"
RDEPENDS:${PN} = "kmod"

do_install() {
    install -Dm0755 ${UNPACKDIR}/nxp-wireless-init ${D}${libexecdir}/nxp-wireless-init
    install -Dm0644 ${UNPACKDIR}/btnxpuart.conf ${D}${sysconfdir}/modprobe.d/btnxpuart.conf
    install -Dm0644 ${UNPACKDIR}/nxp-wireless-init.service ${D}${systemd_system_unitdir}/nxp-wireless-init.service
    sed -i -e 's|@LIBEXECDIR@|${libexecdir}|g' ${D}${systemd_system_unitdir}/nxp-wireless-init.service
}

FILES:${PN} += "${systemd_system_unitdir}/nxp-wireless-init.service"
