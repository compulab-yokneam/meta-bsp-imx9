## Supported Compulab Products

* [UCM-iMX91L - NXP i.MX 91 System-on-Module](https://www.compulab.com/products/computer-on-modules/ucm-imx91l-nxp-i-mx-91-som-system-on-module/)

* [MCM-iMX93 - i.MX93 SMD System-on-Module](https://www.compulab.com/products/computer-on-modules/mcm-imx93-nxp-i-mx-93-som-smd-system-on-module/)

* [UCM-iMX93L - NXP iMX9 System-on-Module](https://www.compulab.com/products/computer-on-modules/ucm-imx93l-nxp-imx9-som-system-on-module/)

* [IOT-LINK Industrial IoT Gateway](https://www.compulab.com/products/iot-gateways/iot-link-industrial-iot-gateway/)

## Build Host Requirements
Preferred OS for build host is Ubuntu 22.04.<br>
It can be utilized with Docker: https://github.com/compulab-yokneam/yocker

## Initialize repo manifests
* NXP:
```
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-scarthgap -m imx-6.18.20-2.2.0.xml
```
* CompuLab:
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/scarthgap/scripts/meta-bsp-imx9.xml
repo sync
```
## Setup Yocto build environment
* Set a machine that matches your board:

| Machine | Command line | Product Page
|---|---|---|
|ucm-imx91|export MACHINE=ucm-imx91|[UCM-iMX91L - NXP i.MX 91 System-on-Module](https://www.compulab.com/products/computer-on-modules/ucm-imx91l-nxp-i-mx-91-som-system-on-module/)|
|ucm-imx93|export MACHINE=ucm-imx93|[MCM-iMX93 - i.MX93 SMD System-on-Module](https://www.compulab.com/products/computer-on-modules/mcm-imx93-nxp-i-mx-93-som-smd-system-on-module/)|
|mcm-imx93|export MACHINE=mcm-imx93|[MCM-iMX93 - i.MX93 SMD System-on-Module](https://www.compulab.com/products/computer-on-modules/mcm-imx93-nxp-i-mx-93-som-smd-system-on-module/)|
|iot-link|export MACHINE=iot-link|[IOT-LINK Industrial IoT Gateway](https://www.compulab.com/products/iot-gateways/iot-link-industrial-iot-gateway/)|

* Set up the environment whether new or already existing:
```
source compulab-setup-env build-${MACHINE}
```
##  Building rootfs image:
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
#### Host Machine ####
```
sudo zstd -dc $image_location | sudo dd bs=1M status=progress of=/dev/sdX
```
#### SoM ####
* Power off
* Insert the created sd-card
* short alt. boot jumper
* Power on
### UUU method
#### Host Machine ####
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
sudo uuu -v -b emmc_all imx-boot-tagged mx-image-full-${MACHINE}.wic.zst
```
#### SoM ####
* Power off
* Connect USB cable from host type A to SoM Serial Download microUSB
* In EVK - short SDP boot jumper
* Power on
## Optional target - bootloader only
```
bitbake -k imx-boot
bootloader_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot-tagged
```
