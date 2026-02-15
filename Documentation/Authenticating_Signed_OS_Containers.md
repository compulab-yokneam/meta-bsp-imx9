This tutorial explains how to sign a kernel image to extend the **Root of Trust** in systems where the OEM is closed.

**Security Scope:** simply booting a signed image is **not sufficient for full security certification**; additional steps like disabling the U-Boot CLI and securing the rootfs boot partition are required

### 1. Create the Image Container
assuming that you cloned https://github.com/compulab-yokneam/meta-bsp-imx9/blob/scarthgap/ for secure boot
```
cd $BBPATH/tmp/deploy/images/$MACHINE
./mkimage_imx8 -soc IMX9 -c -ap path/to/Image a55 0x80400000 --data path/to/dtb a55 0x83000000 -out flash.bin
mv flash.bin flash_os.bin
```

### 2. Sign the Image
Use the **NXP Code Signing Tool (CST)** to sign the container:
- Download the Command Sequence File (CSF) template:
```
wget https://raw.githubusercontent.com/nxp-imx/uboot-imx/refs/heads/lf_v2024.04/doc/imx/ahab/csf_examples/csf_linux_img.txt
```
- **Update the paths** inside csf_linux_img.txt to point to your specific **SRK (Super Root Key)** files.
- Execute the signing command e.g.:
```
/opt/NXP/cst/cst-4.0.1/linux64/bin/cst -i csf_linux_img.txt -o os_cntr_signed.bin
```
copy the output to boot partition (1) of the bootable media

### 3. Verify in U-Boot
obtain the latest boot logic from :
https://github.com/compulab-yokneam/u-boot-compulab/commit/42a7661322af4e44294e304165c7ca532264391d
this can be done by building :
```
bitbake imx-boot
```
on the target:
- Load the image from the MMC:
```
load mmc $mmcdev:1 $cntr_addr os_cntr_signed.bin
```
- Authenticate the container:
```
auth_cntr $cntr_addr
```
- if no error shows you can
```
boot
```
