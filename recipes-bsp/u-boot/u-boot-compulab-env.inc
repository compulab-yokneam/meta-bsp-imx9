FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-compulab-env/imx93:"

SRC_URI:append = " \
	file://fw_env.config \
"

do_install:append () {

	install -d ${D}/etc/
	install -m 0644 ${WORKDIR}/fw_env.config  ${D}/etc/fw_env.config
}

UBOOT_INITIAL_ENV = "u-boot-initial-env"
FILES:${PN}-env += "/etc/*"
RDEPENDS:${PN}-env += "bash"
