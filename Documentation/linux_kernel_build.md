# Building Linux Kernel for CompuLab's i.MX91/93/93(L) products

## Prerequisites
It is up to developers to prepare the host machine; it requires:

* [Setup Cross Compiler](https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/kirkstone/Documentation/toolchain.md#linaro-toolchain-how-to)

## CompuLab Linux Kernel setup

* WorkDir:
```
mkdir -p compulab-kernel/build && cd compulab-kernel
```

* Clone the source code:
```
git clone -b linux-compulab_v6.18.20 https://github.com/compulab-yokneam/linux-compulab.git
cd linux-compulab; mkdir -p lib/firmware
wget -O - https://github.com/compulab-yokneam/bin/raw/linux-firmware/imx-sdma-20230404.tar.bz2 | tar -C lib/firmware/ -xjf -
```

## Compile the Kernel

* Apply the default CompuLab config:
```
make compulab_v8_defconfig compulab.config
```

* Issue menuconfig on order to change the default CompuLab configuration:
```
make menuconfig
```

* Build the kernel
```
nice make -j`nproc` O=build/
```

* [Deploy the CompuLab Linux Kernel to CompuLab devices](https://github.com/compulab-yokneam/Documentation/blob/master/etc/linux_kernel_deployment.md#create-deb-package)
