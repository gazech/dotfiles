#!/usr/bin/bash

# Prevent sourcing - script must be executed
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    echo -e "\033[0;31m❌ ERROR: This script must be executed, not sourced.\033[0m" >&2
    echo "   Usage: ./make_symlinks.sh [OPTIONS]" >&2
    echo "   or:    bash make_symlinks.sh [OPTIONS]" >&2
    return 1 2>/dev/null || exit 1
fi

set -euo pipefail

# Default options
DRY_RUN=false

# Help function
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Create symbolic links from dotfiles to home directory.

OPTIONS:
    -n, --dry-run    Show what would be done without making changes
    -h, --help       Display this help message

ENVIRONMENT VARIABLES:
    DOTFILE_DST_DIR           Target directory (default: ~)
    DOTFILE_BACKUP_EXTENSION  Backup suffix (default: .bak)

EXAMPLES:
    # Preview changes
    ./make_symlinks.sh --dry-run
    
    # Install dotfiles
    ./make_symlinks.sh
    
    # Install to custom location
    DOTFILE_DST_DIR=/tmp/test ./make_symlinks.sh
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

# Wrapper functions for dry-run mode
dry_run_mkdir() {
    local dir="$1"
    if [ "${DRY_RUN}" = "true" ]; then
        echo -e "${_INDENT}\033[0;36m[WOULD CREATE DIR]\033[0m ${dir}"
    else
        mkdir -p "${dir}"
    fi
}

dry_run_mv() {
    local src="$1"
    local dst="$2"
    if [ "${DRY_RUN}" = "true" ]; then
        echo -e "${_INDENT}\033[0;33m[WOULD BACKUP]\033[0m ${src} -> ${dst}"
    else
        mv --verbose --backup=numbered "${src}" "${dst}" | \
            sed -e "s/^/\x1b[2m${_INDENT}/" -e "s/\$/\x1b[0m/" || true
    fi
}

dry_run_ln() {
    local target="$1"
    local link="$2"
    if [ "${DRY_RUN}" = "true" ]; then
        echo -e "${_INDENT}\033[0;32m[WOULD LINK]\033[0m ${link} -> ${target}"
    else
        ln --verbose --symbolic "${target}" "${link}" | \
            sed -e "s/^/\x1b[2m${_INDENT}/" -e "s/\$/\x1b[0m/" || true
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

echo "Defaulting destination folder to ${DOTFILE_DST_DIR}"
echo "Looking in ${DOTFILE_PATH} for dotfiles..."

# go through each dotfile/dir at the top level and make symbolic links for each
# we'll try not to clobber anything so long as we can help it :)
ctr=0
backup_ctr=0
skip_ctr=0
link_ctr=0

# Use safe find with null-delimited output to handle filenames with spaces/newlines
while IFS= read -r -d '' dot; do
    SRC_FULL_PATH="${dot}"
    DST_FULL_PATH="${DOTFILE_DST_DIR}/$(realpath "${dot}" --relative-to="${DOTFILE_PATH}")"

    echo -e "\033[1mcreating link for ${dot}:\033[0m"

    # Check if symlink already points to correct target (idempotency)
    if [ -L "${DST_FULL_PATH}" ] && [ "$(readlink -f "${DST_FULL_PATH}")" = "${SRC_FULL_PATH}" ]; then
        echo -e "${_INDENT}\033[0;32mSKIP\033[0m: symlink already points to correct target"
        ctr=$((ctr + 1))
        skip_ctr=$((skip_ctr + 1))
        continue
    fi

    # create backup to prevent overwrite or script failure
    if [ -e "${DST_FULL_PATH}" ]; then
        if [ -d "$(dirname "${DST_FULL_PATH}")" ]; then
            echo -e "${_INDENT}\033[0;33mWARNING\033[0m: destination ${DST_FULL_PATH} exists; attempting to create a (possibly numbered) backup before continuing"
            dry_run_mv "${DST_FULL_PATH}" "${DST_FULL_PATH}${DOTFILE_BACKUP_EXTENSION}"
            backup_ctr=$((backup_ctr + 1))
        fi
    fi

    if [ ! -d "$(dirname "${DST_FULL_PATH}")" ]; then
        echo -e "${_INDENT}INFO: making parent directories for ${DST_FULL_PATH}"
        dry_run_mkdir "$(dirname "${DST_FULL_PATH}")"
    fi

    dry_run_ln "${SRC_FULL_PATH}" "${DST_FULL_PATH}"
    link_ctr=$((link_ctr + 1))
    ctr=$((ctr + 1))

done < <(find "${DOTFILE_PATH}" -type f -print0)

# Display summary
if [ "${DRY_RUN}" = "true" ]; then
    echo ""
    echo -e "\033[1;36m========================================================"
    echo "  DRY-RUN SUMMARY"
    echo "========================================================"
    echo -e "  Total files processed: ${ctr}"
    echo -e "  Files that would be backed up: ${backup_ctr}"
    echo -e "  Symlinks that would be created: ${link_ctr}"
    echo -e "  Symlinks already correct (skipped): ${skip_ctr}"
    echo "========================================================"
    echo -e "  No changes were made (dry-run mode)"
    echo -e "========================================================\033[0m"
else
    echo -e "\033[7m >> Donezo (${ctr} dotfiles created) << \033[0m"
fi
