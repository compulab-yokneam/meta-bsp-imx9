FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://moal.modprobe.conf \
"

PACKAGES += "${PN}-cfg"

FILES:${PN}-cfg += "/etc/modprobe.d/*"

do_install:append() {
	install -dm 0755 ${D}/${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/sources/moal.modprobe.conf ${D}/etc/modprobe.d/moal.conf
}

RDEPENDS:${PN} += "${PN}-cfg"

PV = "1.0+git${SRCPV}"

EXTRA_OEMAKE = "KERNELDIR=${STAGING_KERNEL_DIR} -C ${STAGING_KERNEL_DIR} M=${S}"
