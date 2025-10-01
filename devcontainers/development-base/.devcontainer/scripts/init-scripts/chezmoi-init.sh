#!/bin/bash
# name: Chezmoi Init
# order: 10
# description: Initialize and apply chezmoi dotfiles

# Check if chezmoi is installed
if ! command -v chezmoi &> /dev/null; then
  echo "chezmoi is not installed. Please install chezmoi first."
  exit 1
fi

# Infer GitHub username
GITHUB_USER=$(gh auth status --show-token 2>/dev/null | grep 'Logged in to github.com account' | awk '{print $7}')
if [ -z "$GITHUB_USER" ]; then
  GITHUB_USER=$(git config --get github.user)
fi
if [ -z "$GITHUB_USER" ]; then
  GITHUB_USER=$(whoami)
fi

REPO_NAME=$(gum input --placeholder "dotfiles.git" --value "dotfiles.git" --prompt "Enter the dotfiles repository name:")
REPO_URL="https://github.com/$GITHUB_USER/$REPO_NAME"

echo "Initializing chezmoi with $REPO_URL in $HOME..."
chezmoi init --apply "$REPO_URL"

echo "chezmoi initialization complete!"

# Mark script as ran
mkdir -p "${HOME}/.ran"
SCRIPT_NAME=$(basename "$0")
touch "${HOME}/.ran/$SCRIPT_NAME"
