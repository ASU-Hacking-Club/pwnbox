#!/bin/bash 
# Install Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Install Plugins
echo | echo | vim +PluginInstall +qall &>/dev/null 

# Complie YouCompleteMe
python3 ~/.vim/bundle/youcompleteme/install.py --all 
