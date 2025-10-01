#!/bin/bash
# Main setup script using gum to display and run init scripts

BANNER="\033[1;32mWelcome! Run development-base/scripts/init-scripts/setup.sh to initialize your container.\033[0m"
echo -e "$BANNER"

INIT_DIR="$(dirname "$0")"
RAN_DIR="$INIT_DIR/.ran"

# Find all scripts with metadata
find "$INIT_DIR" -maxdepth 1 -type f -name "*.sh" | while read -r script; do
  # Extract order and name
  ORDER=$(grep '^# order:' "$script" | awk '{print $3}')
  NAME=$(grep '^# name:' "$script" | cut -d: -f2 | xargs)
  DESC=$(grep '^# description:' "$script" | cut -d: -f2 | xargs)
  RAN=""
  [ -f "$RAN_DIR/$(basename $script)" ] && RAN="[✔]"
  printf "%s|%s|%s|%s|%s\n" "$ORDER" "$NAME" "$DESC" "$script" "$RAN"
done | sort -n > /tmp/init-scripts-list

ALL_SCRIPTS=$(awk -F'|' '{print $4}' /tmp/init-scripts-list)
MENU=$(awk -F'|' '{print $2 " - " $3 " " $5}' /tmp/init-scripts-list)
MENU="Run all scripts\n$MENU"

if [[ "$1" == "--all" ]]; then
  # Run all scripts without asking
  for SCRIPT in $ALL_SCRIPTS; do
    bash "$SCRIPT"
  done
  exit 0
fi

SELECTED=$(echo -e "$MENU" | gum choose --no-limit)

if [[ "$SELECTED" == "Run all scripts" ]]; then
  for SCRIPT in $ALL_SCRIPTS; do
    bash "$SCRIPT"
  done
else
  # Run selected scripts
  while read -r line; do
    SCRIPT=$(awk -F'|' -v name="$line" '$2 " - " $3 " " $5 == name {print $4}' /tmp/init-scripts-list)
    if [ -n "$SCRIPT" ]; then
      bash "$SCRIPT"
    fi
  done <<< "$SELECTED"
fi
