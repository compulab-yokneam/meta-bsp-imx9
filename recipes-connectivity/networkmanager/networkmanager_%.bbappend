PACKAGECONFIG:append = " modemmanager "
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:iot-link = " file://90-iot-link-wifi.conf"
PACKAGE_ARCH:iot-link = "${MACHINE_ARCH}"
PACKAGES:prepend:iot-link = "${PN}-cfg "
FILES:${PN}-cfg = "${sysconfdir}/NetworkManager/conf.d/90-iot-link-wifi.conf"
SUMMARY:${PN}-cfg = "CompuLab IOT-LINK NetworkManager configuration"
RDEPENDS:${PN}:append:iot-link = " ${PN}-cfg"

do_install:append:iot-link() {
    install -Dm0644 ${UNPACKDIR}/90-iot-link-wifi.conf \
        ${D}${sysconfdir}/NetworkManager/conf.d/90-iot-link-wifi.conf
}
