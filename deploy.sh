#!/bin/bash
# deploy.sh — copy configs from repo to ~/
set -e
CONFIGS="$(cd "$(dirname "$0")/configs" && pwd)"
cp -rv "$CONFIGS/." "$HOME/"
echo "Done."
