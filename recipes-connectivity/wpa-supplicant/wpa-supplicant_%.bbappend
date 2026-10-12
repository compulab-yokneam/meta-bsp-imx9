# NXP's defconfig disables the D-Bus control interface, while NetworkManager
# activates wpa_supplicant with -u. Enable it after the NXP configure step.
do_compile:prepend:imx-nxp-bsp() {
    if ! grep -q '^CONFIG_CTRL_IFACE_DBUS_NEW=y$' ${S}/wpa_supplicant/.config; then
        echo 'CONFIG_CTRL_IFACE_DBUS_NEW=y' >> ${S}/wpa_supplicant/.config
    fi
}
