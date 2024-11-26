#!/usr/bin/env bash

PRIVKEY="local-privkey.pem"
PUBKEY="dist/pubkey.pem"
SOFTWARE="dist"

# First, clear out any outdated signatures
for SIGNATURE in "$SOFTWARE"/*/*.rmd160
do
    ARCHIVE_DIR="$(dirname "$SIGNATURE")"
    ARCHIVE="$(basename "$SIGNATURE" .rmd160)"

    if [ "$SIGNATURE" -ot "$ARCHIVE_DIR"/"$ARCHIVE" -o ! -f "$ARCHIVE_DIR"/"$ARCHIVE" ]
    then
        /bin/echo removing outdated signature: "$SIGNATURE"
        /bin/rm -f "$SIGNATURE"
    fi
done

# Now, find every archive that doesn't have a signature
for ARCHIVE in "$SOFTWARE"/*/*.{tbz2,tgz,tar,tbz,tlz,txz,xar,zip,cpgz,cpio}
do
    PORTNAME="$(basename "$(dirname "$ARCHIVE")")"
    ANAME="$(basename "$ARCHIVE")"

    if [ "$ARCHIVE" -nt "$ARCHIVE".rmd160 ]
    then
        /bin/echo -n signing archive: "$ANAME "
        /usr/bin/openssl dgst -ripemd160 -sign "$PRIVKEY" -out "$ARCHIVE".rmd160 "$ARCHIVE"
        /usr/bin/openssl dgst -ripemd160 -verify "$PUBKEY" -signature "$ARCHIVE".rmd160 "$ARCHIVE"
    fi
done
