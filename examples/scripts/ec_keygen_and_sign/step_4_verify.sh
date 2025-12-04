#!/bin/bash

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

set -exo pipefail

openssl pkeyutl -verify -pubin -inkey e0f3_pub.pem -rawin -in test_sign.txt -sigfile test_sign.sig
