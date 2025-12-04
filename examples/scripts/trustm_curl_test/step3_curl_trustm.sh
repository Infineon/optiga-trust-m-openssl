#!/usr/bin/env sh

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

OPENSSL_CONF=cert_ext_trustm.cnf curl \
  --cacert ca/ca.cert.pem \
  --cert client1.crt \
  --key client1.key \
  --verbose \
  https://127.0.0.1:5000/
