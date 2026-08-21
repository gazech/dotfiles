#!/usr/bin/bash

# Prevent sourcing - script must be executed
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo -e "\033[0;31m❌ ERROR: This script must be executed, not sourced.\033[0m" >&2
    echo "   Usage: ./purge_backups.sh [OPTIONS]" >&2
    echo "   or:    bash purge_backups.sh [OPTIONS]" >&2
    return 1 2>/dev/null || exit 1
fi

set -euo pipefail

# Default options
DRY_RUN=false

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Remove backup symlinks created by make_symlinks.sh.
Note: This will NOT remove backup files, only backup symlinks.

OPTIONS:
    -n, --dry-run    Show what would be done without making changes
    -h, --help       Display this help message

ENVIRONMENT VARIABLES:
    DOTFILE_DST_DIR           Target directory (default: ~)
    DOTFILE_BACKUP_EXTENSION  Backup suffix (default: .bak)

EXAMPLES:
    # Preview what would be deleted
    ./purge_backups.sh --dry-run
    
    # Remove backup symlinks
    ./purge_backups.sh
EOF
}

# Parse command-line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --dry-run|-n)
                DRY_RUN=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                echo "Error: Unknown option: $1" >&2
                echo "" >&2
                show_help
                exit 1
                ;;
        esac
    done
}

# Wrapper function for dry-run mode
dry_run_unlink() {
    local link="$1"
    if [ "${DRY_RUN}" = "true" ]; then
        echo -e "    \033[0;33m[WOULD UNLINK]\033[0m \033[2m${link}\033[0m"
    else
        echo -e "    \033[2m${link}\033[0m"
        unlink "${link}"
    fi
}

DOTFILE_DIRNAME="files"
REPO_PATH="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
DOTFILE_PATH="${REPO_PATH}/${DOTFILE_DIRNAME}"

# Parse arguments if running as script (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    parse_args "$@"
fi

if [[ -z ${DOTFILE_BACKUP_EXTENSION:-} ]] || [[ -z ${DOTFILE_DST_DIR:-} ]] || [[ -z ${_INDENT:-} ]]; then
    echo -e "\033[0;31mdotfile env variables not found, running \`${REPO_PATH}/.dfinit.sh\` first...\033[0m"
    source "${REPO_PATH}/.dfinit.sh"
fi

# Display dry-run banner if enabled
if [ "${DRY_RUN}" = "true" ]; then
    echo -e "\033[1;36m"
    echo "========================================================"
    echo "  DRY-RUN MODE - No changes will be made"
    echo "========================================================"
    echo -e "\033[0m"
fi

ctr=0

# Use safe find with null-delimited output to handle filenames with spaces/newlines
while IFS= read -r -d '' dot; do

    DOT_NAME="$(basename "${dot}")"
    DOT_REL_NAME="$(realpath "${dot}" --relative-to="${DOTFILE_PATH}")"
    DOT_DEPTH=$(echo "${DOT_REL_NAME}" | tr -cd '/' | wc -c)
    DOT_DEPTH=$((DOT_DEPTH + 1))

    echo -e "\033[1munlinking the following for ${DOT_REL_NAME}:\033[0m"
    
    # Use safe find with null-delimited output for backup links
    while IFS= read -r -d '' lnk; do
        dry_run_unlink "${lnk}"
        ctr=$((ctr + 1))
    done < <(find "${DOTFILE_DST_DIR}" -maxdepth "${DOT_DEPTH}" -name "${DOT_NAME}*${DOTFILE_BACKUP_EXTENSION}*" -type l -print0 2>/dev/null || true)
    
    echo ""

done < <(find "${DOTFILE_PATH}" -type f -print0)

# Display summary
if [ "${DRY_RUN}" = "true" ]; then
    echo -e "\033[1;36m========================================================"
    echo "  DRY-RUN SUMMARY"
    echo "========================================================"
    echo -e "  Backup symlinks that would be deleted: ${ctr}"
    echo "========================================================"
    echo -e "  No changes were made (dry-run mode)"
    echo -e "========================================================\033[0m"
else
    echo -e "\033[7m >> Donezo (${ctr} dotfile backups deleted) << \033[0m"
fi
