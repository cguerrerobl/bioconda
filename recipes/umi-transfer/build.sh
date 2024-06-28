#!/bin/bash -euo pipefail
export CFLAGS="${CFLAGS} -fcommon"
export CXXFLAGS="${CXXFLAGS} -fcommon"
export RUSTFLAGS="-C link-arg=-s"

# Add workaround for SSH-based Git connections from Rust/cargo.  See https://github.com/rust-lang/cargo/issues/2078 for details.
# We set CARGO_HOME because we don't pass on HOME to conda-build, thus rendering the default "${HOME}/.cargo" defunct.
export CARGO_NET_GIT_FETCH_WITH_CLI=true CARGO_HOME="$(pwd)/.cargo"

# build statically linked binary with Rust
RUST_BACKTRACE=1 cargo install --verbose --locked --root $PREFIX --path .

if command -v ldd &> /dev/null; then
    if ! ldd $PREFIX/bin/umi-transfer | grep "not a dynamic executable" &> /dev/null; then
        echo "Error: umi-transfer is not statically linked."
        exit 1
    fi
fi