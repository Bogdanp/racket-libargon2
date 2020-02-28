#!/usr/bin/env bash

set -euxo pipefail

git submodule update --init
pushd argon2
export PREFIX="$(pwd)/../artifacts/linux-x86-64"

make clean
make
make install
strip "$PREFIX/lib/x86_64-linux-gnu/libargon2.so.1"
popd
