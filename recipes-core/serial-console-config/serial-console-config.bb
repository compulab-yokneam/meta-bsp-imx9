SUMMARY = "CompuLab serial console configuration"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://serial-getty-no-osc.conf \
    file://serial-console-term.sh \
"

S = "${UNPACKDIR}"

do_install() {
    install -d ${D}${sysconfdir}/systemd/system/serial-getty@ttyLP0.service.d
    install -m 0644 ${UNPACKDIR}/serial-getty-no-osc.conf \
        ${D}${sysconfdir}/systemd/system/serial-getty@ttyLP0.service.d/10-no-osc.conf

    install -d ${D}${sysconfdir}/profile.d
    install -m 0644 ${UNPACKDIR}/serial-console-term.sh \
        ${D}${sysconfdir}/profile.d/99-serial-console-term.sh
}

FILES:${PN} = " \
    ${sysconfdir}/systemd/system/serial-getty@ttyLP0.service.d/10-no-osc.conf \
    ${sysconfdir}/profile.d/99-serial-console-term.sh \
"
