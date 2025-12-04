#!/usr/bin/env sh

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

PROJECT_DIR=$(dirname "$(dirname "$(dirname "$(pwd)")")")
CERT_PATH=ca/
TRUSTM_PROVIDER_PATH="$PROJECT_DIR/bin"

SERVER_FILE=server1
CLIENT_FILE=client1
