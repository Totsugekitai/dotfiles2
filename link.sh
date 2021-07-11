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

link clang-format ~/.clang-format
link init.el ~/.emacs.d/init.el
link tmux.conf ~/.tmux.conf
