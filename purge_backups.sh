#!/usr/bin/bash

if [[ -z ${DOTFILE_BACKUP_EXTENSION} ]] || [[ -z ${DOTFILE_DST_DIR} ]] || [[ -z ${_INDENT} ]]; then
    echo -e "\033[0;31mdotfile env variables not found, run \`dfinit.sh\` first; exiting...\033[0m"
    # Return for sourced scripts, exit for direct execution
    [[ "${BASH_SOURCE[0]}" != "${0}" ]] && return 1 || exit 1
fi

REPO_PATH=$(dirname $(readlink -e ${BASH_SOURCE[0]}))
DOTFILE_PATH=${REPO_PATH}/${DOTFILE_DIRNAME}

ctr=0 
for dot in `find ${DOTFILE_PATH} -type f`; do

    DOT_NAME=`basename ${dot}`
    DOT_REL_NAME=`realpath ${dot} --relative-to=${DOTFILE_PATH}`

    echo -e "\033[1munlinking the following for ${DOT_NAME}:\033[0m"
    for lnk in `find ${DOTFILE_DST_DIR} -name "${DOT_NAME}*${DOTFILE_BACKUP_EXTENSION}*" -type l`; do
        echo -e "    \033[2m${lnk}\033[0m"
        unlink ${lnk}
        ((ctr++))
    done
    echo ""

done

echo -e "\033[42m >> Donezo (${ctr} dotfile backups deleted) << \033[0m"