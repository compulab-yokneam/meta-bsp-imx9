FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://moal.modprobe.conf \
"

PACKAGES += "${PN}-cfg"

# Yebian emits Debian packages, whose upstream version must start with a digit.
# Give the configuration-only package an independent Debian-compatible version.
NXP_WLAN_CFG_VERSION ?= "1.0.0"
PKGV:${PN}-cfg = "${NXP_WLAN_CFG_VERSION}"

FILES:${PN}-cfg += "/usr/lib/modules-load.d/*"
FILES:${PN}-cfg += "/etc/modprobe.d/*"

do_install:append() {
	install -dm 0755 ${D}/usr/lib/modules-load.d/
	echo "moal" > ${D}/${libdir}/modules-load.d/10moal.conf
	echo "btnxpuart" > ${D}/${libdir}/modules-load.d/20btnxpuart.conf

	install -dm 0755 ${D}/${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/moal.modprobe.conf ${D}/etc/modprobe.d/moal.conf
}

RDEPENDS:${PN} += "${PN}-cfg"
