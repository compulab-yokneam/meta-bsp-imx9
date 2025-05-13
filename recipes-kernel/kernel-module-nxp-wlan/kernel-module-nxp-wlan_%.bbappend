FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " file://moal.modules-load.conf "
SRC_URI:append:iot-link = " file://moal.modprobe.conf.nxpiw612"
SRC_URI:append:default = " file://moal.modprobe.conf"

FILES:${PN} += " \
    /etc/modules-load.d/moal.conf \
    /etc/modprobe.d/moal.conf \
"

do_install:append() {
    install -d ${D}/etc/modules-load.d
    install -m 0644 ${WORKDIR}/moal.modules-load.conf ${D}/etc/modules-load.d/moal.conf

    install -d ${D}/etc/modprobe.d
	if [ -f "${WORKDIR}/moal.modprobe.conf.nxpiw612" ]; then
        install -m 0644 ${WORKDIR}/moal.modprobe.conf.nxpiw612 ${D}/etc/modprobe.d/moal.conf
    else
        install -m 0644 ${WORKDIR}/moal.modprobe.conf ${D}/etc/modprobe.d/moal.conf
    fi
}
