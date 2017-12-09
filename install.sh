#!/bin/sh

if [ $# -eq 0 ]; then
  echo "usage: $0 <directory>"
  exit 1
fi

cd "$1" || exit 1
cp -as "$PWD/." ~/

# the dot is important!
# https://stackoverflow.com/questions/3643848/copy-files-from-one-directory-into-an-existing-directory
# https://askubuntu.com/questions/86822/how-can-i-copy-the-contents-of-a-folder-to-another-folder-in-a-different-directo/86844
