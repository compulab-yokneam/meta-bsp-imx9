# Configuring the build
**Preferred OS for build host is Ubuntu 22.04. It can be utilized with Docker: https://github.com/compulab-yokneam/yocker**
## Setup Yocto environment

* WorkDir:
```
mkdir compulab-nxp-bsp && cd compulab-nxp-bsp
```
* Set a CompuLab machine:

```
export MACHINE=ucm-imx93
```

## Initialize repo manifests

* NXP
```
repo init -u https://github.com/nxp-imx/imx-manifest.git -b imx-linux-mickledore -m imx-6.1.55-2.2.0.xml
```

* CompuLab
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/mickledore-6.1.55-2.0/scripts/meta-bsp-imx9.xml
repo sync
```
## Setup build environment

* Initialize the build environment:
```
source compulab-setup-env -b build-${MACHINE}
```

##  Building full rootfs image:

* Build command 
```
bitbake -k imx-image-full
```
* binary file location: `${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-image-full-${MACHINE}.wic.bz2`


## Deployment
### Create a live SD card

```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
```

* Deploy the image:
```
sudo zstd -dc imx-image-full-${MACHINE}-*.rootfs.wic.zst | sudo dd bs=1M status=progress of=/dev/sdd
```

## Optional targets
* Building bootloader only:
```bitbake -k imx-boot```

* binary file location: `${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot-tagged`
