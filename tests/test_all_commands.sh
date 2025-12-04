#!/bin/bash

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

rm *.sig
rm *.pem
rm *.txt

set -e
echo "input" >mydata.txt

echo "-----> Openssl Provider: ECC Key Gen"
openssl pkey -provider trustm_provider -in 0xe0f1:*:NEW:0x03:0x33 -pubout -out e0f1_pub.pem
openssl pkey -provider trustm_provider -in 0xe0f2:*:NEW:0x03:0x33 -pubout -out e0f2_pub.pem
openssl pkey -provider trustm_provider -in 0xe0f3:*:NEW:0x03:0x33 -pubout -out e0f3_pub.pem


for i in $(seq 1 5); do
echo "$(date +'%m/%d:%r') --------------> test $i"

openssl rand -provider trustm_provider -base64 32 &
openssl rand -provider trustm_provider -base64 32 &
openssl rand -provider trustm_provider -base64 32 &
openssl rand -provider trustm_provider -base64 32 &


echo "-----> Openssl Provider:Ecc Signature256 by TrustM:"
openssl pkeyutl -provider trustm_provider -inkey 0xe0f1:^  -sign -rawin -in mydata.txt -out test_sign_e0f1.sig &
echo "-----> Openssl Provider:Ecc Signature256 by TrustM:"
openssl pkeyutl -provider trustm_provider -inkey 0xe0f2:^  -sign -rawin -in mydata.txt -out test_sign_e0f2.sig &
echo "-----> Openssl Provider:Ecc Signature256 by TrustM:"
openssl pkeyutl -provider trustm_provider -inkey 0xe0f3:^  -sign -rawin -in mydata.txt -out test_sign_e0f3.sig &

#~ echo "--------------> waiting 60s .."
#~ sleep 160
done
