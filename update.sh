#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f local-privkey.pem ]]; then
  scripts/gen-keys.sh
fi

source config.local.sh

set -x
rsync -a --info=progress2 "$TIGER_HOST:/opt/local/var/macports/software"'/*' dist
{ set +x; } 2> /dev/null

scripts/gen-signatures.sh
scripts/gen-html.rb
