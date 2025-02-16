LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://Licenses/gpl-2.0.txt;md5=b234ee4d69f5fce4486a80fdaf4a4263"
SRCBRANCH = "u-boot-compulab_v2024.04"
SRC_URI = "git://github.com/compulab-yokneam/u-boot-compulab;protocol=https;branch=${SRCBRANCH}"
SRCREV = "2d2dd77f1591770fad348b7e5355ad77012d35be"

DEPENDS += " python3-setuptools-native "
