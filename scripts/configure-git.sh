#!/bin/bash

# Configure Git
git config --global user.name "Ryan C. Durham"
git config --global user.email ryan@stagerightlabs.com
git config --global core.editor "vim"
git config --global push.default simple
git config --global pull.rebase false
git config --global init.defaultBranch main

# signing commits in vscode:
# https://devmount.medium.com/signed-git-commits-in-vs-code-476fb74b8773
# git config --global user.signingkey [SIGNATURE]
# git config --global commit.gpgsign true
