#!/bin/bash

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

set -exo pipefail

echo "testing SHA-256 message digest" | openssl dgst -provider trustm_provider -sha256
