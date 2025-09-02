# Building Linux Kernel for CompuLab's i.MX93 products

## Prerequisites
It is up to developers to prepare the host machine; it requires:

* [Setup Cross Compiler](https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/kirkstone/Documentation/toolchain.md#linaro-toolchain-how-to)

## CompuLab Linux Kernel setup

* WorkDir:
```
mkdir -p compulab-kernel/build && cd compulab-kernel
```

* Set a machine that matches your board:

| Machine | Command line |
|---|---|
|ucm-imx93|export MACHINE=ucm-imx93|
|mcm-imx93|export MACHINE=mcm-imx93|
|iot-link|export MACHINE=iot-link|

* Clone the source code:
```
git clone -b linux-compulab_v6.6.52-rt https://github.com/compulab-yokneam/linux-compulab.git
```

## Compile the Kernel
* Apply the CompuLab config:
```
make compulab-mx93_defconfig 
```
* To change the default CompuLab configuration run:
```
make menuconfig
```

* Build the kernel
```
nice make -j`nproc` O=build/
```

* [Deploy the CompuLab Linux Kernel to CompuLab devices](https://github.com/compulab-yokneam/Documentation/blob/master/etc/linux_kernel_deployment.md#create-deb-package)
