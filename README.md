# CompuLab IOT-LINK BSP Layer

This repository was created as the base Yocto Project BSP layer for building a Debian 12 distribution for CompuLab IOT-LINK devices.

## Supported Compulab Products
[IOT-LINK Industrial IoT Gateway](https://www.compulab.com/products/iot-gateways/iot-link-industrial-iot-gateway/)

**Preferred OS for build host is Ubuntu 22.04. It can be utilized with Docker: https://github.com/compulab-yokneam/yocker**
## Initialize repo manifests
* NXP:
```
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-scarthgap -m imx-6.6.52-2.2.0.xml
```
* CompuLab:
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/iot-link-1.2-snap/scripts/meta-bsp-imx9.xml
repo sync
```
## Setup Yocto build environment
* Set a machine
```
export MACHINE=iot-link
```
* Set up the environment (new or existing):
```
source compulab-setup-env build-${MACHINE}
```
##  Building rootfs image:
```
bitbake -k fsl-image-network-full-cmdline
IMAGE_DIR=${BUILDDIR}/tmp/deploy/images/${MACHINE}
IMAGE_NAME=fsl-image-network-full-cmdline-${MACHINE}.rootfs-*.wic.zst
BL_NAME=imx-boot-tagged
```
## Deployment
### Bootable media
#### Host Machine ####
```
sudo zstd -dc ${IMAGE_DIR}/${IMAGE_NAME} | sudo dd bs=1M status=progress of=/dev/sdX
```
#### SoM ####
* Power off
* Insert the created media
* Power on
### UUU method (for advanced developers)
#### Host Machine ####
```
cd ${IMAGE_DIR}
sudo uuu -v -b emmc_all ${BL_NAME} ${IMAGE_NAME}
```
#### SoM ####
* Power off
* Connect USB cable from host type A to SoM Serial Download microUSB
* In EVK - short SDP boot jumper
* Power on
## Optional target - bootloader only
```
bitbake -k imx-boot
```
