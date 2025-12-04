#!/bin/bash

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

rm -d -r -f  demoCA*

rm *.csr
rm *.pem

mkdir demoCA
cd demoCA
touch index.txt
mkdir private
mkdir newcerts
