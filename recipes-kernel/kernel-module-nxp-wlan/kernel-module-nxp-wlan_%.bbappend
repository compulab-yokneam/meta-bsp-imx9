FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://moal.modules-load.conf \
    file://moal.modprobe.conf \
"

PACKAGES += "${PN}-cfg"

FILES:${PN}-cfg += " \
    /etc/modules-load.d/moal.conf \
    /etc/modprobe.d/moal.conf \
"

do_install:append() {
    install -d ${D}/etc/modules-load.d
    install -m 0644 ${WORKDIR}/moal.modules-load.conf ${D}/etc/modules-load.d/moal.conf
    install -d ${D}/etc/modprobe.d
    install -m 0644 ${WORKDIR}/moal.modprobe.conf ${D}/etc/modprobe.d/moal.conf
}

RDEPENDS:${PN} += "${PN}-cfg"
