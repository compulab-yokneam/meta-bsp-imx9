FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:iot-link = " \
	https://github.com/Ezurio/Connectivity_Stack_Release_Packages/releases/download/LRD-REL-13.98.0.12/summit-nx61x-1218-firmware-13.98.0.12.tar.bz2;name=nx61x-firmware;subdir=summit \
"

SRC_URI[nx61x-firmware.sha256sum] = 'a1f3b5198fa4901a5ec32d1967d4d3d3497b0ee90eabe073912ca962295812f9'
SUMMIT_DIR:iot-link = "${WORKDIR}/summit/lib/firmware"

do_install:append:iot-link() {
	install -d ${D}${nonarch_base_libdir}/firmware/nxp
	for f in ${SUMMIT_DIR}/nxp/1218_rgpower* ${SUMMIT_DIR}/nxp/sduart_nw61x* ${SUMMIT_DIR}/nxp/wifi_prod_params.conf; do
		install -m 0644 $f ${D}${nonarch_base_libdir}/firmware/nxp/
	done
	for f in ${SUMMIT_DIR}/nxp/1218_rgpower*; do
		filename=$(basename "$f")
		destname="${filename#1218_}"
		ln -sf "$filename" "${D}${nonarch_base_libdir}/firmware/nxp/$destname"
	done
}

# add to package
FILES:${PN}-nxpiw612-sdio:append:iot-link = " \
    ${nonarch_base_libdir}/firmware/nxp/sduart_nw61x_* \
    ${nonarch_base_libdir}/firmware/nxp/*rgpower* \
    ${nonarch_base_libdir}/firmware/nxp/wifi_prod_params.conf \
"
