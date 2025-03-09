#!/usr/bin/bash

if [[ -z ${DOTFILE_BACKUP_EXTENSION} ]]; then
    echo -e "\033[0;31mDOTFILE_BACKUP_EXTENSION env variable not found; exiting...\033[0m"
    return 1
fi

if [[ -z ${DOTFILE_DST_DIR} ]]; then
    echo "\033[0;31mDOTFILE_DST_DIR env variable not found; exiting...\033[0m"
    return 1
fi

REPO_PATH=$(dirname $(readlink -e ${BASH_SOURCE[0]}))
DOTFILE_PATH=${REPO_PATH}/${DOTFILE_DIRNAME}

for dot in `find ${DOTFILE_PATH} -type f`; do

    DOT_NAME=`basename ${dot}`
    DOT_REL_NAME=`realpath ${dot} --relative-to=${DOTFILE_PATH}`

    echo -e "\033[1munlinking the following for ${DOT_NAME}:\033[0m"
    for lnk in `find ${DOTFILE_DST_DIR} -name "${DOT_NAME}*${DOTFILE_BACKUP_EXTENSION}*" -type l`; do
        echo -e "    \033[0;90m${lnk}\033[0m"
        unlink ${lnk}
    done
    echo ""

done