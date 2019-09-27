#!/bin/bash
INSTALL_DIR=~/.local/bin
echo ""
echo mkdir -p ${INSTALL_DIR}
mkdir -p ${INSTALL_DIR}
echo cp bookmark.sh ${INSTALL_DIR}

if [[ ! -f "~/.bashrc" ]];then
    echo source ${INSTALL_DIR}/bookmark.sh >> ~/.bashrc
fi

if [ ! -f "~/.zshrc" ];then
    echo source ${INSTALL_DIR}/bookmark.sh >> ~/.zshrc
fi

echo ""
echo ''
echo 'USAGE:'
echo '------'
echo 'b  - Bookmark list'
echo 'a  - Add the current directory to bookmark'
echo 't <bookmark_index>  - Goes (cd) to the directory associated with "bookmark_index"'
echo 'r <bookmark_index> ...  - Deletes the bookmark with index'
echo 'c - Deletes all bookmark'
echo ""
