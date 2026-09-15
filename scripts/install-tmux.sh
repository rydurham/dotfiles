#!/bin/bash

sudo apt install build-essential libevent-dev libncurses-dev yacc -y

wget https://github.com/tmux/tmux/releases/download/3.7/tmux-3.7.tar.gz

tar -zxvf tmux-3.7.tar.gz
cd tmux-3.7
./configure
make
sudo make install
cd ..
rm -rf tmux-3.7
rm tmux-3.7.tar.gz
