# Disclaimer                                                                                                                                                                                                                                                                    

| !IMPORTANT! | This branch is not a release |
|---|---|

## Supported Compulab Products
[MCM-iMX93 - i.MX93 SMD System-on-Module](https://www.compulab.com/products/computer-on-modules/mcm-imx93-nxp-i-mx-93-som-smd-system-on-module/)

**Preferred OS for build host is Ubuntu 22.04. It can be utilized with Docker: https://github.com/compulab-yokneam/yocker**
## Initialize repo manifests
* NXP:
```
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-scarthgap -m imx-6.6.23-2.0.0.xml
```
* CompuLab:
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/scarthgap/scripts/meta-bsp-imx9.xml
repo sync
```
## Setup Yocto build environment
* Set a machine that matches your SoM:
```
export MACHINE=ucm-imx93
```
```
export MACHINE=mcm-imx93
```
* Initialize the environment:
```
source compulab-setup-env build-${MACHINE}
```
##  Building full rootfs image:
* Build command
```
bitbake -k imx-image-full
image_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-image-full-${MACHINE}*.wic.zst
```
## Deployment
### Bootable sd card method
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
* Short SDP boot jumper
* Power on
## Optional target - bootloader only
```
bitbake -k imx-boot
bootloader_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot-tagged
```
