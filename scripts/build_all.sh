#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-latest}"
PUSH_FLAG=""

if [[ "${@: -1}" == "--push" ]]; then
    PUSH_FLAG="--push"
fi

for dir in devcontainers/*; do
    NAME=$(basename "$dir")
    ./scripts/build_one.sh "$NAME" "$VERSION" $PUSH_FLAG
done
echo "✅ All images built successfully with version: ${VERSION}"
