#!/bin/bash 
# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install Plugins
vim +PluginInstall +qall 

# Complie YouCompleteMe
python3 ~/.vim/bundle/youcompleteme/install.py --all 
