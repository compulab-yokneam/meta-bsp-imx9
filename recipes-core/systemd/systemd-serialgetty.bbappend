do_install:append:${MACHINE}() {
    if [ -f ${D}${systemd_unitdir}/system/serial-getty@.service ]; then
        sed -i 's/\(ExecStart=-\/sbin\/agetty\)/\1 -a root/' ${D}${systemd_unitdir}/system/serial-getty@.service 
    fi
}
