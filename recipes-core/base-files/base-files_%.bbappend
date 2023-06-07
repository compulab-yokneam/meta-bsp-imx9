do_install_basefilesissue:append () {
    for issue_file in issue issue.net;do
        printf "CompuLab BSP Release 1.0 with Linux Kernel \\\r\n" >> ${D}${sysconfdir}/${issue_file}
        echo >> ${D}${sysconfdir}/${issue_file}
    done
}
