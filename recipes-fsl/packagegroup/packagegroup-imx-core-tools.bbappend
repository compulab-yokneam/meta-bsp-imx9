# The vendor 6.18 tree contains a newer PCI endpoint self-test than its
# pcitest UAPI. Do not install a test binary that cannot match the kernel ABI.
RDEPENDS:${PN}:remove:compulab-mx93 = "kernel-tools-pci"
