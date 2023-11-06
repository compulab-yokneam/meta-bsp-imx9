# Configuring the build

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
repo init -u git://github.com/nxp-imx/imx-manifest.git -b imx-linux-mickledore -m imx-6.1.22-2.0.0.xml
```

* CompuLab
```
mkdir -p .repo/local_manifests
wget --directory-prefix .repo/local_manifests https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/mickledore/scripts/meta-bsp-imx9.xml
```

* Sync Them all
```
repo sync
```
## Setup build environment

* Initialize the build environment:
```
source compulab-setup-env -b build-${MACHINE}
```

##  Building full rootfs image:

| Build Target | Build command | binary file location |
|---|---|---|
| full rootfs image |```bitbake -k imx-image-full```|```${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-image-full-${MACHINE}.wic.bz2```|


## Deployment
### Create a live SD card

* Goto the `${BUILDDIR}/tmp/deploy/images/${MACHINE}` directory:
```
cd ${BUILDDIR}/tmp/deploy/images/${MACHINE}
```

* Deploy the image:
```
zstd -dc imx-image-full-${MACHINE}.wic.zst > imx-image-full-${MACHINE}.wic
sudo bmaptool copy --bmap imx-image-full-${MACHINE}.wic.bmap imx-image-full-${MACHINE}.wic /dev/sdX
```

## Optional targets
* Building bootloader only:

| Build Target | Build command | binary file location |
|---|---|---|
| bootloader |```bitbake -k imx-boot```|```${BUILDDIR}/tmp/deploy/images/${MACHINE}/imx-boot-tagged```|
