FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
# Default case for other machines
SRC_URI += "file://0001-wifi_mod_para.conf-change-fw-to-enable-sdio-BT.patch"

SRC_URI:append:iot-link = " \
	https://github.com/Ezurio/SonaNX-Release-Packages/releases/download/LRD-REL-12.103.8.3/summit-nx61x-firmware-12.103.8.3.tar.bz2;name=nx61x-firmware;subdir=summit \
"

SRC_URI[nx61x-firmware.md5sum] = '014cc5fac9752449500fff642ff97b5a'
SRC_URI[nx61x-firmware.sha256sum] = 'cbd9b84dac10739983e16001ca3c64ab99fe681fee4b17cbfe1197f1fc039ff8'
SUMMIT_DIR:iot-link = "${WORKDIR}/summit/lib/firmware"

do_install:append:iot-link() {
    install -d ${D}${nonarch_base_libdir}/firmware/nxp
    for f in ${SUMMIT_DIR}/nxp/rgpower* ${SUMMIT_DIR}/nxp/sduart_nw61x* ${SUMMIT_DIR}/nxp/wifi_prod_params.conf; do
        install -m 0644 $f ${D}${nonarch_base_libdir}/firmware/nxp/
    done
}

FILES:${PN}-nxpiw612-sdio:append:iot-link = " \
    ${nonarch_base_libdir}/firmware/nxp/sduart_nw61x_* \
    ${nonarch_base_libdir}/firmware/nxp/rgpower* \
    ${nonarch_base_libdir}/firmware/nxp/wifi_prod_params.conf \
"
