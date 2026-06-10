SUMMARY = "CAN interface configuration and udev rules"
DESCRIPTION = "Keep persisting names according to physical CAN devices"
LICENSE = "CLOSED"

SRC_URI = "file://51-can.rules"

do_install() {
    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${WORKDIR}/51-can.rules ${D}${sysconfdir}/udev/rules.d/
}
