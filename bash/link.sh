#!/usr/bin/env bash

set -v

# git completion scripts:
# Arch:   /usr/share/git/completion
# Fedora: /usr/share/git-core/contrib/completion
# Ubuntu: none
# upstream:
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ln -sf $DIR/resources/profile      ~/.profile
ln -sf $DIR/resources/bash_profile ~/.bash_profile
ln -sf $DIR/resources/bash_aliases ~/.bash_aliases
ln -sf $DIR/resources/bashrc       ~/.bashrc
ln -sf $DIR/resources/bashrc.d     ~/.bashrc.d
ln -sf $DIR/resources/tmux.conf    ~/.tmux.conf
ln -sf $DIR/resources/gitconfig    ~/.gitconfig

set +v
