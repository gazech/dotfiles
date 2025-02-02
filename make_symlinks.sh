#!/usr/bin/bash

export DOTFILE_DST_DIR=`readlink -e ~`
export DOTFILE_BACKUP_EXTENSION=".bak"

DOTFILE_DIRNAME="files"
REPO_PATH=$(dirname $(readlink -e ${BASH_SOURCE[0]}))
DOTFILE_PATH=${REPO_PATH}/${DOTFILE_DIRNAME}

echo "Defaulting destination folder to ${DOTFILE_DST_DIR}"
echo "Looking in ${DOTFILE_PATH} for dotfiles..."

# go through each dotfile/dir at the top level and make symbolic links for each
# we'll try not to clobber anything so long as we can help it :)
for dot in `ls -1Aq ${DOTFILE_PATH}`; do 
    SRC_FULL_PATH=`readlink -e ${DOTFILE_PATH}/${dot}`
    DST_FULL_PATH=${DOTFILE_DST_DIR}/${dot}
 
    # create backup to prevent overwrite or script failure
    if [ -e ${DST_FULL_PATH} ]; then
        echo -e "\033[0;33mWARNING\033[0m: destination ${DST_FULL_PATH} exits; attempting to create a (possibly numbered) backup before continuing"
        mv --verbose --backup=numbered ${DST_FULL_PATH} "${DST_FULL_PATH}${DOTFILE_BACKUP_EXTENSION}"
    fi

    ln --verbose --symbolic ${SRC_FULL_PATH} ${DST_FULL_PATH}

done        

