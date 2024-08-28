#!/bin/bash

sudo apt install build-essential libevent-dev libncurses-dev -y

wget https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz

tar -zxvf tmux-3.4.tar.gz
cd tmux-3.4
./configure
make
sudo make install
cd ..
rm -rf tmux-3.4
rm tmux-3.4.tar.gz
