#!/usr/bin/env sh

# SPDX-FileCopyrightText: 2025 Infineon Technologies AG
#
# SPDX-License-Identifier: MIT

. ${PWD}/config.sh

openssl s_server \
  -cert ${SERVER_FILE}.crt \
  -key ${SERVER_FILE}.key \
  -accept 5000 \
  -verify_return_error \
  -Verify 1 \
  -CAfile $CERT_PATH/ca.cert.pem \
  -www
