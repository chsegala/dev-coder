#!/usr/bin/env bash
set -euo pipefail

USERNAME="chsegala"
REGISTRY="ghcr.io"
NAMESPACE="${USERNAME}"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <image-folder> [version] [--push]"
    echo "Example: $0 development-base v1.0.0 --push"
    exit 1
fi

IMAGE_FOLDER="$1"
VERSION="${2:-latest}"
PUSH=false

# Check for --push flag
if [[ "${@: -1}" == "--push" ]]; then
    PUSH=true
fi

IMAGE="${REGISTRY}/${NAMESPACE}/${IMAGE_FOLDER}"

echo "📦 Building image: ${IMAGE}:${VERSION}"

# if $PUSH; then
#     echo "🔑 Logging in to GitHub Container Registry..."
#     echo "${GH_TOKEN:-}" | docker login "${REGISTRY}" -u "${USERNAME}" --password-stdin
# fi

echo "🔨 Building the image for amd64 and arm64..."
cd "$(dirname "$0")/../devcontainers/${IMAGE_FOLDER}" || exit 1

echo "🔨 Building the image for amd64..." 
devcontainer build --workspace-folder "." --image-name "${IMAGE}:${VERSION}" --platform linux/amd64 

echo "🔨 Building the image for arm64..." 
devcontainer build --workspace-folder "." --image-name "${IMAGE}:${VERSION}" --platform linux/arm64 

if $PUSH; then
    echo "🏷 Tagging as latest..."
    docker tag "${IMAGE}:${VERSION}" "${IMAGE}:latest"
    # docker tag "${IMAGE}:${VERSION}" "${IMAGE}:latest"

    echo "🚀 Pushing ${IMAGE}:${VERSION}-amd64 and latest-amd64..."
    docker push "${IMAGE}:${VERSION}" 
    docker push "${IMAGE}:latest" 
    # echo "🚀 Pushing ${IMAGE}:${VERSION}-arm64 and latest..."
    # docker push "${IMAGE}:${VERSION}" --platform linux/arm64
    # docker push "${IMAGE}:latest" --platform linux/arm64
else
    echo "✅ Build complete (push skipped)"
fi
