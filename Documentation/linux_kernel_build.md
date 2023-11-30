# Building CompuLab Linux Kernel for i.MX93 products

## Prerequisites
* [Setup Cross Compiler](https://github.com/compulab-yokneam/meta-bsp-imx8mp/blob/kirkstone/Documentation/toolchain.md#linaro-toolchain-how-to)

## Setup

* WorkDir:
```
mkdir -p compulab-kernel/build && cd compulab-kernel
```

* Set a CompuLab machine:
```
export MACHINE=ucm-imx93
```

* Clone the source code:
```
git clone -b linux-compulab_v6.1.22 https://github.com/compulab-yokneam/linux-compulab.git
cd linux-compulab/
```

## Compile
* Apply the default CompuLab config:
```
make ${MACHINE}_defconfig compulab.config O=../build/
```

* if you want to change the default CompuLab configuration run:
```
make menuconfig O=../build/
```

* Build
```
make -j`nproc` O=../build/
```

* [Deploy the CompuLab Linux Kernel to CompuLab devices](https://github.com/compulab-yokneam/Documentation/blob/master/etc/linux_kernel_deployment.md#create-deb-package)
