FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://moal.modprobe.conf \
"

PACKAGES += "${PN}-cfg"

FILES:${PN}-cfg += "/usr/lib/modules-load.d/*"
FILES:${PN}-cfg += "/etc/modprobe.d/*"

do_install:append() {
	install -dm 0755 ${D}/usr/lib/modules-load.d/
	echo "moal" > ${D}/${libdir}/modules-load.d/modules.conf
	echo "btnxpuart" >> ${D}/${libdir}/modules-load.d/modules.conf

	install -dm 0755 ${D}/${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/moal.modprobe.conf ${D}/etc/modprobe.d/moal.conf
}

RDEPENDS:${PN} += "${PN}-cfg"

PV = "1.0+git${SRCPV}"
