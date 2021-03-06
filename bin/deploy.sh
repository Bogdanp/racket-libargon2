#!/usr/bin/env bash

set -euo pipefail

log() {
    printf "[%s] %s\n" "$(date)" "$@"
}

log "Ensuring artifact folders are present..."
test -e artifacts/linux-x86-64 || exit 2
test -e artifacts/macos-aarch64 || exit 2
test -e artifacts/macos-x86-64 || exit 2
test -e artifacts/win32-i386 || exit 2
test -e artifacts/win32-x86-64 || exit 2

log "Copying artifacts into their respective packages..."
cp artifacts/linux-x86-64/lib/x86_64-linux-gnu/libargon2.so.1 libargon2-x86_64-linux/libargon2.so
cp artifacts/macos-aarch64/lib/libargon2.1.dylib libargon2-aarch64-macosx/libargon2.dylib
cp artifacts/macos-x86-64/lib/libargon2.1.dylib libargon2-x86_64-macosx/libargon2.dylib
cp artifacts/win32-i386/libargon2.dll libargon2-i386-win32/libargon2.dll
cp artifacts/win32-x86-64/libargon2.dll libargon2-x86_64-win32/libargon2.dll

log "Decrypting deploy key..."
gpg -q \
    --batch \
    --yes \
    --decrypt \
    --passphrase="$DEPLOY_KEY_PASSPHRASE" \
    -o deploy-key \
    bin/deploy-key.gpg
chmod 0600 deploy-key
trap "rm -f deploy-key" EXIT

log "Building packages..."
for package in "libargon2-aarch64-macosx" "libargon2-x86_64-linux" "libargon2-x86_64-macosx" "libargon2-i386-win32" "libargon2-x86_64-win32"; do
    log "Building '$package'..."
    pushd "$package"

    version=$(grep version info.rkt | cut -d'"' -f2)
    filename="$package-$version.tar.gz"
    mkdir -p dist
    tar -cvzf "dist/$filename" LICENSE info.rkt libargon2.*
    sha1sum "dist/$filename" | cut -d ' ' -f 1 | tr -d '\n' > "dist/$filename.CHECKSUM"
    scp -o StrictHostKeyChecking=no \
        -i ../deploy-key \
        -P "$DEPLOY_PORT" \
        "dist/$filename" \
        "dist/$filename.CHECKSUM" \
        "$DEPLOY_USER@$DEPLOY_HOST":~/www/

    popd
done
