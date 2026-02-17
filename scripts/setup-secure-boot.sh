#!/bin/bash
set -e

# Setup Secure Boot for iMX93
# This script handles CST installation, key generation, and Yocto configuration

INSTALL_PATH="${1:-/opt/NXP/cst}"
CST_FILE="${2}"
CST_VERSION="${3:-4.0.1}"
BBPATH="${BBPATH:-.}"

if [ -z "$CST_FILE" ]; then
    echo "Usage: $0 [INSTALL_PATH] CST_FILE [CST_VERSION]"
    echo "Example: $0 /opt/NXP/cst ~/Downloads/cst-$CST_VERSION.tgz"
    exit 1
fi

echo "Installing CST to $INSTALL_PATH..."
sudo mkdir "$INSTALL_PATH" -p
gzip -dc "$CST_FILE" | sudo tar -x -C "$INSTALL_PATH"

echo "Generating Security Keys (SRK)..."
cd "$INSTALL_PATH/cst-$CST_VERSION/keys" 2> /dev/null || cd "$INSTALL_PATH/release/keys"
./ahab_pki_tree.sh <<EOF
n
ecc
p256
sha256
5
n
EOF

echo "Configuring Yocto..."
cat << EOF >> "$BBPATH/conf/local.conf"
SIG_TOOL_PATH = "$INSTALL_PATH/cst-$CST_VERSION"
EOF

echo "Creating Required Symlinks..."
cd "$INSTALL_PATH/cst-$CST_VERSION/keys"
for i in {1..4}; do 
    ln -s SRK${i}_sha256_secp256r1_v3_usr_key.pem SRK${i}_sha256_prime256v1_v3_ca_key.pem
done

cd ../crts/
for i in {1..4}; do 
    ln -s SRK${i}_sha256_secp256r1_v3_usr_crt.pem SRK${i}_sha256_prime256v1_v3_ca_crt.pem
done

echo "Generating SRK Table and Hash..."
cd ../keys
../linux64/bin/srktool -a -d sha256 -s sha256 -t SRK_1_2_3_4_table.bin -e SRK_1_2_3_4_fuse.bin -f 1 -c SRK1_sha256_secp256r1_v3_usr_crt.pem,SRK2_sha256_secp256r1_v3_usr_crt.pem,SRK3_sha256_secp256r1_v3_usr_crt.pem,SRK4_sha256_secp256r1_v3_usr_crt.pem

cd $BBPATH/../sources/
git clone git@github.com:nxp-imx-support/meta-nxp-security-reference-design.git
bitbake-layers add-layer ../sources/meta-nxp-security-reference-design/meta-secure-boot

echo "Setup Complete!"
echo "Next: Build signed image: bitbake imx-boot-signature"
