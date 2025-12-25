## Demo Tutorial: Enabling AHAB Secure Boot on iMX93 based products
This tutorial outlines the steps necessary to integrate the NXP Code Signing Tool (CST) into the Compulab Yocto build environment, generate security keys, sign the bootloader, and permanently fuse the Super Root Key (SRK) hash onto the MCM-iMX93 but it works also for UCM-IMX93 and iot-link
### Support and Documentation
1. Compulab provides support for the integration of AHAB Secure Boot, as it is a major strategic development goal for the i.MX9 platform. The implementation involves utilizing the NXP CST tool.
2. **Documentation:** The underlying Yocto layer integration code is available at https://github.com/compulab-yokneam/meta-bsp-imx9/commit/e30e93408b9114185263b90b28c627326475df03 which provides support for this feature.
### Phase 1: Prepare Yocto Sources and Integrate Security Layer
1. **Prepare Yocto Sources:** Initialize and synchronize 
https://github.com/compulab-yokneam/meta-bsp-imx9/blob/scarthgap/README.md
2. **Add Security Layer:** Add the NXP Security Reference Design layer to your build environment:
```
cd ../sources/
git clone git@github.com:nxp-imx-support/meta-nxp-security-reference-design.git
bitbake-layers add-layer ../sources/meta-nxp-security-reference-design/meta-secure-boot
```
### Phase 2: Download and Install NXP CST
The NXP Code Signing Tool (CST) cannot be downloaded automatically by Yocto due to NXP licensing requirements.
1. **Download CST:** Manually download the latest version of the CST from the [NXP CST Download Page](https://www.nxp.com/search?keyword=cst%2520tools&start=0)
2. **Extract:**
```
INSTALL_PATH="/opt/NXP/cst"
sudo mkdir $INSTALL_PATH -p
gzip -dc <CST_FILE.tgz> | sudo tar -x -C $INSTALL_PATH
```
### Phase 3: Generate and Install Security Keys (SRK)
- Required for the device's Root of Trust
- Based on https://github.com/nxp-imx/uboot-imx/blob/lf_v2024.04/doc/imx/ahab/introduction_ahab.txt
```
cd /opt/NXP/cst/cst-4.0.1/keys
./ahab_pki_tree.sh
# Respond to prompts:
# Do you want to use an existing CA key (y/n)?: n
# Select the key type (possible values: rsa, rsa-pss, ecc)?: ecc
# Enter length for elliptic curve...: p256
# Enter the digest algorithm to use: sha256
# Enter PKI tree duration (years): 5
# Do you want the SRK certificates to have the CA flag set? (y/n)?: n
```
* **Integrate CST Path:** Set the path to the CST tool within your Yocto configuration by appending it to `local.conf`:
```
cat << eof >> $BBPATH/conf/local.conf
SIG_TOOL_PATH = "/opt/NXP/cst/cst-4.0.1"
eof
```
* **Fix Build Errors (Symlinks):** The build system looks for files named with the ECC parameters you selected (`prime256v1`) that differ from the NXP default links (`secp256r1`). Run the following solution:
```
cd /opt/NXP/cst/cst-4.0.1/keys
```
```
for i in {1..4}; do ln -s SRK${i}_sha256_secp256r1_v3_usr_key.pem SRK${i}_sha256_prime256v1_v3_ca_key.pem; done
cd ../crts/
for i in {1..4}; do ln -s SRK${i}_sha256_secp256r1_v3_usr_crt.pem SRK${i}_sha256_prime256v1_v3_ca_crt.pem; done
```

* Generating SRK Table and SRK Hash in Linux 64-bit machines:
```
../linux64/bin/srktool -a -d sha256 -s sha256 -t SRK_1_2_3_4_table.bin -e SRK_1_2_3_4_fuse.bin -f 1 -c \
SRK1_sha256_secp256r1_v3_usr_crt.pem,\
SRK2_sha256_secp256r1_v3_usr_crt.pem,\
SRK3_sha256_secp256r1_v3_usr_crt.pem,\
SRK4_sha256_secp256r1_v3_usr_crt.pem
```

1. **Build Signed Image:** 
```
bitbake imx-boot-signature
```
boot e.g.:
```
sudo uuu $BBPATH/tmp/deploy/images/mcm-imx93/signed-imx-boot-mcm-imx93-sd.bin-flash_singleboot
```
run:
```
ahab_status 
```
You will see `IND - 0xFA (ELE_BAD_KEY_HASH_FAILURE_IND)`; because when the i.MX93 ROM/ELE verifies a signed image, it compares its hash to the value stored in the **Hash Fuses** and since you haven't burned them yet, they are set to factory default state and the hash in your image does not match them
### Phase 4: Fusing the SRK Hash and Advancing the Lifecycle
This phase makes the Secure Boot permanent on the device.
- Based on https://github.com/nxp-imx/uboot-imx/blob/lf_v2025.04/doc/imx/ahab/guides/mx8ulp_9x_secure_boot.txt#L395
- **⚠️ WARNING: These steps are irreversible. If your keys are lost or incorrect, the board will be permanently bricked.**
1. **Fuse the SRK Hash:** Fuse the hash of your generated public keys (Super Root Keys) into the device fuses. This tells the device's hardware (the ELE) which key to trust for authentication.
a. **Generate Fuse Script:** Inspect the fuse data binary:
```
cd /opt/NXP/cst/cst-4.0.1/crts
od -t x4 SRK_1_2_3_4_fuse.bin
```

b. For parsing convenience use [generate_fuses.py](generate_fuses.py) on the fuse binary to generate the fusion commands:
```
od -t x4 /opt/NXP/cst/cst-4.0.1/crts/SRK_1_2_3_4_fuse.bin| python3 <(curl -fsSL https://raw.githubusercontent.com/compulab-yokneam/meta-bsp-imx9/refs/heads/scarthgap/Documentation/generate_fuses.py)
```
1. **Advance Lifecycle:** After the SRK hash is fused, advance the device lifecycle from "OEM Open" to "OEM Closed" using the U-Boot command:
```
ahab_close
```
