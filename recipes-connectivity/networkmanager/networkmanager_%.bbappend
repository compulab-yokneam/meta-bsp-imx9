PACKAGECONFIG:append = " modemmanager ppp "

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append:iot-link = " file://90-iot-link-wifi.conf"
PACKAGE_ARCH:iot-link = "${MACHINE_ARCH}"

do_install:append:iot-link() {
    install -Dm0644 ${UNPACKDIR}/90-iot-link-wifi.conf \
        ${D}${sysconfdir}/NetworkManager/conf.d/90-iot-link-wifi.conf
}
