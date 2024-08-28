#!/bin/bash

sudo add-apt-repository ppa:aslatter/ppa
sudo apt install alacritty
# add term info - https://github.com/alacritty/alacritty/issues/3962#issuecomment-862212371
curl -sSL https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info | tic -x -
