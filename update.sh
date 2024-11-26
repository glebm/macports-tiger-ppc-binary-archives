#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f local-privkey.pem ]]; then
  scripts/gen-keys.sh
fi

source config.local.sh

set -x
scripts/restore-mtimes.rb
rsync -a --delete --info=progress2 --exclude=/pubkey.pem --exclude='*.rmd160' "$TIGER_HOST:/opt/local/var/macports/software"'/*' dist
{ set +x; } 2> /dev/null
for f in dist/*/*.rmd160; do
  if ! [[ -f "${f%.rmd160}" ]]; then
    rm "$f"
  fi
done

scripts/gen-signatures.sh
scripts/gen-html.rb
