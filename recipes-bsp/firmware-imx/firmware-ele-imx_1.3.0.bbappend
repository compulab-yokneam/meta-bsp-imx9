SRC_URI[sha256sum] = "2d29f0a4de3662ba15f6a7d9069702d4eaed415d96a17f29d5b127f2c6fdd634"
SRC_URI = "${FSL_MIRROR}/firmware-ele-imx-2.0.2-89161a8.bin;fsl-eula=true"
S = "${WORKDIR}/firmware-ele-imx-2.0.2-89161a8"
do_populate_lic[noexec] = "1"
