#!/bin/bash

# SPDX-FileCopyrightText: Copyright (c) 2026 Infineon Technologies AG
# SPDX-License-Identifier: MIT

sudo apt update 
sudo apt -y install git gcc libssl-dev gpiod libgpiod-dev curl \
                    python3 python3-jinja2 python3-jsonschema perl

(
    echo "-----> Generate mbedtls config files" 
    cd external/optiga-trust-m/external/mbedtls-4.x 
    python3 framework/scripts/make_generated_files.py
)
(
    echo "-----> Generate PSA config files"
    cd external/optiga-trust-m/external/mbedtls-4.x/tf-psa-crypto
    python3 framework/scripts/make_generated_files.py
)

set -e
echo "-----> Build Trust M provider"
sudo make uninstall
make clean
make -j5
sudo make install

echo "-----> Generate Test CA key and Certificate for testing"
cd examples/scripts/
export IFX_CERT_PATH=certificates/OPTIGA_Trust_M_Infineon_Test_CA.pem
export IFX_CERT_KEY=certificates/OPTIGA_Trust_M_Infineon_Test_CA_Key.pem

declare -i ErrorCount=0

clear 2>/dev/null || true

if [ -e $IFX_CERT_KEY ]
then
    echo "TEST CA key ok"
else
    if [ ! -d certificates ]
    then
    mkdir certificates
    fi
    echo "Generate Test CA Key"
    openssl ecparam -out $IFX_CERT_KEY -name prime256v1 -genkey
    echo "Generate Test CA Certificate"
    openssl req -new -x509 -days 3650 -key $IFX_CERT_KEY -subj "/CN=Infineon OPTIGA(TM) Trust M Test CA/O=Infineon Technologies AG/OU=OPTIGA(TM)/C=DE" -out $IFX_CERT_PATH
fi

echo "Generated Test CA"

