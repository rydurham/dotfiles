#!/bin/bash

sudo apt install build-essential libevent-dev libncurses-dev yacc -y

wget https://github.com/tmux/tmux/releases/download/3.5/tmux-3.5.tar.gz

tar -zxvf tmux-3.5.tar.gz
cd tmux-3.5
./configure
make
sudo make install
cd ..
rm -rf tmux-3.5
rm tmux-3.5.tar.gz
