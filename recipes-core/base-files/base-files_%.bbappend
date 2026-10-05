CL_RELEASE ?= "1.0"
CL_STRING = "Compulab BSP Release"
do_install_basefilesissue:append () {
    for issue_file in issue issue.net;do
	sed -e "/^${CL_STRING}/d" -i ${D}/etc/$issue_file
	sed -e " 1 i $(date +"${CL_STRING} ${MACHINE} ${CL_RELEASE} %y.%m based on")" -i ${D}/etc/$issue_file
    done
}

do_install:append:cl-imx93() {
    cat >> ${D}${sysconfdir}/fstab <<'EOF'
# Use the EEPROM-derived CompuLab platform name as the system hostname.
/proc/device-tree/som.info/board.name /etc/hostname none bind,defaults,nofail 0 0
EOF
}
