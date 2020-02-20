#!/usr/bin/env bash

set -euxo pipefail

git submodule update --init

pushd argon2
export PREFIX="$(pwd)/../artifacts/macos-x86-64"

make clean
make
make install
popd
