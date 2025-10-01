#!/bin/bash
# name: Login Banner
# order: 1
# description: Display login banner for init scripts

BANNER="\033[1;32mWelcome! Run /usr/local/init-scripts/setup.sh to initialize your container.\033[0m"
echo -e "$BANNER"
