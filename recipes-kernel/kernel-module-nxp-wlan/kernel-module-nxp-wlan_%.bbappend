FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://moal.modprobe.conf \
"

PACKAGES += "${PN}-cfg"

FILES:${PN}-cfg += "/usr/lib/modules-load.d/*"
FILES:${PN}-cfg += "/etc/modprobe.d/*"

do_install:append() {
	if ${@bb.utils.contains('MACHINE_FEATURES', 'nxpiw612-sdio', 'true', 'false', d)}; then
		install -dm 0755 ${D}/usr/lib/modules-load.d/
        echo "moal" > ${D}/${libdir}/modules-load.d/10moal.conf
        echo "btnxpuart" > ${D}/${libdir}/modules-load.d/20btnxpuart.conf

        install -dm 0755 ${D}/${sysconfdir}/modprobe.d
		install -m 0644 ${WORKDIR}/moal.modprobe.conf ${D}/etc/modprobe.d/moal.conf
    fi
}

RDEPENDS:${PN} += "${PN}-cfg"
