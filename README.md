# Supported Compulab Products
[MCM-iMX93 - i.MX93 SMD System-on-Module](https://www.compulab.com/products/computer-on-modules/mcm-imx93-nxp-i-mx-93-som-smd-system-on-module/)
[IOT-LINK Industrial IoT Gateway](https://www.compulab.com/products/iot-gateways/iot-link-industrial-iot-gateway/)

**Preferred OS for build host is Ubuntu 22.04. It can be utilized with [Docker](https://github.com/compulab-yokneam/yocker)**
# Initialize repo
* Set a machine that matches your board:

| Machine | Command line |
|---|---|
|mcm-imx93|export MACHINE=mcm-imx93|
|iot-link|export MACHINE=iot-link|

## Setup build environment
* NXP:
```
export BSP=$(pwd)/compulab-${SOC}-bsp
mkdir ${BSP} && cd ${BSP}
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-walnascar -m imx-6.12.34-2.1.0.xml
```
* CompuLab:
```
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/walnascar/scripts/meta-bsp-imx9.xml
repo sync
```
* Set up the environment:
```
source compulab-setup-env build-${MACHINE}
```
#  Building rootfs image:
* For EVK run:
```
bitbake -k imx-image-full
image_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-image-full-${MACHINE}*.wic.zst
```
* For IOT-LINK run:
```
bitbake -k fsl-image-network-full-cmdline
image_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/fsl-image-network-full-cmdline-${MACHINE}.rootfs-*.wic.zst
```
## Deployment
### Bootable sd card method - not for IOT-LINK
#### Host Machine
```
sudo zstd -dc $image_location | sudo dd bs=1M status=progress of=/dev/sdX
```
#### SoM
* Power off
* Insert the created sd-card
* short alt. boot jumper
* Power on
### UUU method
#### Host Machine
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
sudo uuu -v -b emmc_all imx-boot-tagged mx-image-full-${MACHINE}.wic.zst
```
#### SoM
* Power off
* Connect USB cable from host type A to SoM Serial Download microUSB
* In EVK - short SDP boot jumper
* Power on
# Building bootloader only
```
bitbake -k imx-boot
bootloader_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot-tagged
```
## Deployment
### Bootable sd card method
```
sudo dd if=imx-boot bs=1K seek=32 of=/dev/sdX
```
### UUU method
* Host Machine
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
sudo uuu -b emmc imx-boot-tagged
```
