SUMMARY = "WWAN configuration (udev rules and network interfaces)"
DESCRIPTION = "Rename usb0 to wwan0 and make it down at startup"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://50-wwan0.rules \
    file://wwan0 \
"

do_install() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/50-wwan0.rules ${D}${sysconfdir}/udev/rules.d/

    install -d ${D}${sysconfdir}/network/interfaces.d
    install -m 0644 ${WORKDIR}/wwan0 ${D}${sysconfdir}/network/interfaces.d/
}
