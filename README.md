## Supported Compulab Products
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
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-wrynose -m imx-6.18.20-2.0.0.xml
```
* CompuLab:
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/wrynose/scripts/meta-bsp-imx9.xml
repo sync
```

## Setup Yocto build environment
* Set a machine that matches your board:

| Machine | Command line | Product Page
|---|---|---|
|cl-imx93|export MACHINE=cl-imx93|Unified image for UCM-i.MX93 and MCM-i.MX93 EVKs; platform selected by U-Boot|
|iot-link|export MACHINE=iot-link|[IOT-LINK Industrial IoT Gateway](https://www.compulab.com/products/iot-gateways/iot-link-industrial-iot-gateway/)|

* Set up the environment whether new or already existing:
```
source compulab-setup-env build-${MACHINE}
```

##  Building rootfs image:
* Build the common release image for the selected machine:
```
bitbake cl-imx9
IMAGE=${BUILDDIR}/tmp/deploy/images/${MACHINE}/cl-imx9-${MACHINE}.rootfs.wic.zst
```

## Deployment
### From external media
* On IOT-LINK the only external media available is USB
* With USB, the bootloader loads from eMMC, and with SD card from the card itself

#### Host Machine
```
sudo zstd -dc  $(readlink -f $IMAGE) | sudo dd bs=1M status=progress of=/dev/sdX
```

#### SoM
* Power off
* Insert the created media
* short alt. boot jumper
* Power on

### UUU method
#### Host Machine ####
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
sudo uuu -v -b emmc_all imx-boot-tagged cl-imx9-${MACHINE}.rootfs.wic.zst
```

#### SoM ####
* Power off
* Connect USB cable from host type A to SoM Serial Download microUSB
* In EVK - short SDP boot jumper
* Power on

## Optional target - bootloader only
```
bitbake -k imx-boot
bootloader_location=${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot
```
