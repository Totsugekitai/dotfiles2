#!/bin/bash

PWD=`pwd`

link()
{
    if [ ! -f $PWD/$1 ]; then
        echo -e 'no such file' "\t$1"
        exit
    fi
    if [ ! -h $2 ]; then
        ln -s $PWD/$1 $2
        echo '[link]' "$1" 'to' "$2"
    else
        echo -e "$2\t" 'is already linked'
    fi
}

oh-my-bash_install()
{
    if [ -d $HOME/.oh-my-bash ]; then
        echo 'on-my-bash is already installed'
    else
        bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
    fi
}

oh-my-bash_install

link clang-format $HOME/.clang-format
link init.el $HOME/.emacs.d/init.el
link tmux.conf $HOME/.tmux.conf
link bashrc $HOME/.bashrc
link bash_profile $HOME/.bash_profile
link i3wm.conf $HOME/.config/i3/config
