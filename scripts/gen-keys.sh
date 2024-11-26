#!/usr/bin/env bash
set -x
openssl genrsa -out local-privkey.pem 2048
openssl rsa -in local-privkey.pem -pubout -out dist/pubkey.pem
{ set +x; } 2> /dev/null
