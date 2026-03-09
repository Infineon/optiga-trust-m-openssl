#!/bin/bash

# SPDX-FileCopyrightText: Copyright (c) 2025 Infineon Technologies AG
# SPDX-License-Identifier: MIT


set +e

rm -d -r -f  demoCA* || true

rm *.csr || true
rm *.pem || true

mkdir demoCA
cd demoCA
touch index.txt
mkdir private
mkdir newcerts
