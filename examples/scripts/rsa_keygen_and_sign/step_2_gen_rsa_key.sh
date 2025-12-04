#!/bin/bash

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

set -exo pipefail

# Generate RSA 2048 key in 0xE0FD (key usage auth/enc/sign) and extract public key file
openssl pkey -provider trustm_provider -in 0xe0fd:*:NEW:0x42:0x13 -pubout -out e0fd_pub.pem
