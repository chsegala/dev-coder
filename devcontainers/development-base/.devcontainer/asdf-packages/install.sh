#!/usr/bin/env bash

set -e

source ./library_scripts.sh
ensure_nanolayer nanolayer_location "v0.4.39"

declare -a plugins_to_install=("zoxide")
for plugin in "${plugins_to_install[@]}"; do
    $nanolayer_location \
        install \
        devcontainer-feature \
        "ghcr.io/devcontainers-extra/features/asdf-package:1" \
        --option plugin="$plugin"
done
