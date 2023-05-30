SRC_URI:append = " \
	file://0000-compulab-imx9-Add-ucm-imx93-board-support.patch \
	file://0001-ucm-imx93-dts-draft-00.patch \
	file://0002-ucm-imx93-dts-draft-pmic.patch \
	file://0003-ucm-imx93-dts-Add-ethernet-aliases.patch \
	file://0004-video-draft-00.patch \
	file://0005-video-draft-01.patch \
	file://0006-video-draft-02.patch \
	file://0007-rtc-draft-00.patch \
	file://0008-wifi-draft-00.patch \
	file://0009-video-draft-03.patch \
	file://0010-wifi-draft-01.patch \
	file://0011-som-imx8m-plus-dts-Disable-uart1-dma.patch \
	file://0012-som-imx8m-plus-dts-Add-marvell-sd8897-bt-provision.patch \
	file://0013-panel-small-fixes.patch \
	file://0014-marvell-fixes.patch \
	file://0015-panel-fixes.patch \
	file://0016-panel-timings-logics-update.patch \
	file://0017-panel-timing-fixes.patch \
	file://0018-panel-small-fixes.patch \
	file://0019-ucm-imx93-dts-Update-panel-timing-node.patch \
	file://0020-ili9881c-Update-the-driver-file.patch \
	file://0021-ucm-imx93-defconfig-Update-config-file.patch \
	file://0022-ucm-imx93-config-Add-compulab-ucm-imx93.config-file.patch \
	file://0023-ucm-imx93-dts-Add-ucm-imx93-lvds.dts.patch \
	file://0024-ucm-imx93-dts-Split-into-3-file-set.patch \
	file://0025-ucm-imx93-dtsi-Remove-panel-stuff.patch \
	file://0026-ucm-imx93-dts-Add-mipi-panel-overlay.patch \
	file://0027-ucm-imx93-dts-Add-lvds-panel-overlay.patch \
	file://0028-ucm-imx93-dts-Makefile-Add-overlays-to-build.patch \
	file://0029-ucm-imx93-dts-Minor-refactoring.patch \
	file://0030-ucm-imx93-dts-Disable-backlight.patch \
	file://0031-ucm-imx93-dts-lvds-Clean-up-overlay-tags.patch \
	file://0032-ucm-imx93-dts-Move-pca9555-to-i2c3.patch \
	file://defconfig \
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
