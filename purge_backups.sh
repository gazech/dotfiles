#!/usr/bin/bash

DOTFILE_DIRNAME="files"
REPO_PATH=$(dirname $(readlink -e ${BASH_SOURCE[0]}))
DOTFILE_PATH=${REPO_PATH}/${DOTFILE_DIRNAME}

if [[ -z ${DOTFILE_BACKUP_EXTENSION} ]] || [[ -z ${DOTFILE_DST_DIR} ]] || [[ -z ${_INDENT} ]]; then
    echo -e "\033[0;31mdotfile env variables not found, running \`${REPO_PATH}/.dfinit.sh\` first...\033[0m"
    source ${REPO_PATH}/.dfinit.sh
fi

ctr=0 
for dot in `find ${DOTFILE_PATH} -type f`; do

    DOT_NAME=`basename ${dot}`
    DOT_REL_NAME=`realpath ${dot} --relative-to=${DOTFILE_PATH}`
    DOT_DEPTH=$((`echo ${DOT_REL_NAME} | grep -o / | wc -l` + 1))

    echo -e "\033[1munlinking the following for ${DOT_REL_NAME}:\033[0m"
    for lnk in `find  ${DOTFILE_DST_DIR} -maxdepth ${DOT_DEPTH} -name "${DOT_NAME}*${DOTFILE_BACKUP_EXTENSION}*" -type l  2> /dev/null`  ; do
        echo -e "    \033[2m${lnk}\033[0m"
        unlink ${lnk}
        ((ctr++))
    done
    echo ""

done

echo -e "\033[7m >> Donezo (${ctr} dotfile backups deleted) << \033[0m"
