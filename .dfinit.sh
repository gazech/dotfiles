#!/usr/bin/bash
set -euo pipefail

# Resolve home directory to absolute path (only if not already set)
if [[ -z ${DOTFILE_DST_DIR:-} ]]; then
    export DOTFILE_DST_DIR
    DOTFILE_DST_DIR="$(readlink -f ~)"
fi

export DOTFILE_BACKUP_EXTENSION="${DOTFILE_BACKUP_EXTENSION:-.bak}"
export _INDENT="${_INDENT:-    }"

echo "DOTFILE_DST_DIR=${DOTFILE_DST_DIR}"
echo "DOTFILE_BACKUP_EXTENSION=${DOTFILE_BACKUP_EXTENSION}"
