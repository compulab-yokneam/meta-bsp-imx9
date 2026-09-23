# The serial getty starts with TERM=dumb to suppress systemd's OSC 3008
# service and PAM session metadata. Restore a useful terminal type only after
# authentication, when that metadata has already been emitted or suppressed.
case "$(tty 2>/dev/null)" in
    /dev/ttyLP*) export TERM=vt100 ;;
esac
