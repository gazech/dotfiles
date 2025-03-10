#!/usr/bin/bash

if [[ -z ${DOTFILE_BACKUP_EXTENSION} ]] || [[ -z ${DOTFILE_DST_DIR} ]] || [[ -z ${_INDENT} ]]; then
    echo -e "\033[0;31mdotfile env variables not found, run \`dfinit.sh\` first; exiting...\033[0m"
    # Return for sourced scripts, exit for direct execution
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
fi

DOTFILE_DIRNAME="files"
REPO_PATH=$(dirname $(readlink -e ${BASH_SOURCE[0]}))
DOTFILE_PATH=${REPO_PATH}/${DOTFILE_DIRNAME}

echo "Defaulting destination folder to ${DOTFILE_DST_DIR}"
echo "Looking in ${DOTFILE_PATH} for dotfiles..."

# go through each dotfile/dir at the top level and make symbolic links for each
# we'll try not to clobber anything so long as we can help it :)
ctr=0
for dot in `find ${DOTFILE_PATH} -type f`; do
    SRC_FULL_PATH="${dot}"
    DST_FULL_PATH="${DOTFILE_DST_DIR}"/`realpath ${dot} --relative-to="${DOTFILE_PATH}"`

    echo -e "\033[1mcreating link for ${dot}:\033[0m"

    # create backup to prevent overwrite or script failure
    if [ -e "${DST_FULL_PATH}" ] && [ -e $(dirname "${DST_FULL_PATH}") ]; then
        echo -e "${_INDENT}\033[0;33mWARNING\033[0m: destination ${DST_FULL_PATH} exists; attempting to create a (possibly numbered) backup before continuing"
        mv --verbose --backup=numbered "${DST_FULL_PATH}" "${DST_FULL_PATH}${DOTFILE_BACKUP_EXTENSION}" | \
            sed -e "s/^/\x1b[2m${_INDENT}/" -e "s/\$/\x1b[0m/"
    fi

    if [ ! -e $(dirname ${DST_FULL_PATH}) ]; then
        echo -e "${_INDENT}INFO: making parent directories for ${DST_FULL_PATH}"
        mkdir -p  $(dirname "${DST_FULL_PATH}")
    fi

    ln --verbose --symbolic "${SRC_FULL_PATH}" "${DST_FULL_PATH}"  | \
        sed -e "s/^/\x1b[2m${_INDENT}/" -e "s/\$/\x1b[0m/"

    ((ctr++))

done

echo -e "\033[42m >> Donezo (${ctr} dotfiles created) << \033[0m"