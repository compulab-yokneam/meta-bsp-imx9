## Supported Compulab Machines 
[MCM-iMX93 - i.MX93 SMD System-on-Module](https://www.compulab.com/products/computer-on-modules/mcm-imx93-nxp-i-mx-93-som-smd-system-on-module/)

**Preferred OS for build host is Ubuntu 22.04. It can be utilized with Docker: https://github.com/compulab-yokneam/yocker**
## Initialize repo manifests
* NXP:
```
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-nanbield -m imx-6.6.3-1.0.0.xml
```
* CompuLab:
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/sbc-mcm-imx93-r1.0/scripts/meta-bsp-imx9.xml
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
source compulab-setup-env -b build-${MACHINE}
```
##  Building full rootfs image:
* Build command
```
bitbake -k imx-image-full
image_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-image-full-${MACHINE}*.wic.zst
```
* Deploy the image to a live SD card
```
sudo zstd -dc $image_location | sudo dd bs=1M status=progress of=/dev/sdX
```
## Optional target - bootloader
```
bitbake -k imx-boot
bootloader_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot-tagged
```
