SRC_URI:append = " \
	file://defconfig \
	file://linux-firmware-sdma.cfg \
"

SRC_URI:append:ucm-imx93 = " https://github.com/compulab-yokneam/bin/raw/linux-firmware/imx-sdma-20230404.tar.bz2;name=imx-sdma-firmware "
SRC_URI[imx-sdma-firmware.md5sum] = "a1169448bf2f020a3f48f51c4961022a"
SRC_URI[imx-sdma-firmware.sha256sum] = "004ad1f9cf5b1176e71765794a5bfdcffdf44b9a5c1545188a171554bf4439a1"

do_patch:append() {
    if [ ! -d ${WORKDIR}/imx ];then
        return
    fi
    mkdir -p ${S}/lib/firmware/
    cp -rfv ${WORKDIR}/imx ${S}/lib/firmware/
}
