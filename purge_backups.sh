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

for dot in `ls -1Aq ${DOTFILE_PATH}`; do 

    echo -e "\033[1munlinking the following for ${dot}:\033[0m"
    for lnk in `find ${DOTFILE_DST_DIR} -name "${dot}*${DOTFILE_BACKUP_EXTENSION}*"`; do
        echo -e "    \033[0;90m${lnk}\033[0m"
        unlink ${lnk}
    done
    echo ""

done        

