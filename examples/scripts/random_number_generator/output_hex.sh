#!/bin/bash

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

set -exo pipefail

openssl rand -provider trustm_provider -hex 32
