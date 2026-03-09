#!/bin/bash

# SPDX-FileCopyrightText: Copyright (c) 2025 Infineon Technologies AG
# SPDX-License-Identifier: MIT

source config.sh


set +e

rm *.pub || true
rm *.bin || true
rm *.pem || true
rm *.csr || true
rm *.crt || true
set -e


