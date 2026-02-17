## Demo Tutorial: Enabling AHAB Secure Boot on iMX93 based products
### Prepare Yocto Sources
https://github.com/compulab-yokneam/meta-bsp-imx9/blob/scarthgap/README.md
### Install CST
The NXP Code Signing Tool (CST) cannot be downloaded automatically by Yocto due to NXP licensing requirements.

1. **Download CST:** Manually download the latest version of the CST from the [NXP CST Download Page](https://www.nxp.com/search?keyword=cst%2520tools&start=0)

2. **Run Setup Script:** Use the automated setup script to install CST, generate keys, and configure Yocto:
```bash
bash <(curl -sL https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/refs/heads/scarthgap/scripts/setup-secure-boot.sh) /opt/NXP/cst ~/Downloads/cst-4.0.1.tgz 4.0.1
```

3. **Add Security Layer and Build:**
```bash
bitbake imx-boot-signature
```

boot e.g.:
```
sudo uuu $BBPATH/tmp/deploy/images/$MACHINE/signed-imx-boot-$MACHINE-sd.bin-flash_singleboot
```
run:
```
ahab_status
```
You will see `IND - 0xFA (ELE_BAD_KEY_HASH_FAILURE_IND)`; because when the i.MX93 ROM/ELE verifies a signed image, it compares its hash to the value stored in the **Hash Fuses** and since you haven't burned them yet, they are set to factory default state and the hash in your image does not match them
### Fusing the SRK Hash and Advancing the Lifecycle
This phase makes the Secure Boot permanent on the device.
- Based on https://github.com/nxp-imx/uboot-imx/blob/lf_v2025.04/doc/imx/ahab/guides/mx8ulp_9x_secure_boot.txt#L395
- **⚠️ WARNING: These steps are irreversible. If your keys are lost or incorrect, the board will be permanently bricked.**
1. **Fuse the SRK Hash:** Fuse the hash of your generated public keys (Super Root Keys) into the device fuses. This tells the device's hardware (the ELE) which key to trust for authentication.
a. **Generate Fuse Script:** Inspect the fuse data binary:
```
cd /opt/NXP/cst/cst-4.0.1/crts
od -t x4 SRK_1_2_3_4_fuse.bin
```

b. For parsing convenience use generate_fuses.py on the fuse binary to generate the fusion commands:
```
od -t x4 /opt/NXP/cst/cst-4.0.1/crts/SRK_1_2_3_4_fuse.bin| python3 <(curl -fsSL https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/refs/heads/scarthgap/Documentation/generate_fuses.py)
```
1. **Advance Lifecycle:** After the SRK hash is fused, advance the device lifecycle from "OEM Open" to "OEM Closed" using the U-Boot command:
```
ahab_close
```
## Signing a kernel image to extend the **Root of Trust** after the OEM is closed.

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
copy os_cntr_signed.bin to the target's boot partition (1) of the bootable media

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
- if no error shows you can proceed with:
```
boot
```
