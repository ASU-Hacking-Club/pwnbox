FROM angr/angr
MAINTAINER zbasque@asu.edu 

# ----- Setup Enviornment ----- #
# rename main user to pwndevil
USER root 
RUN usermod -l pwndevil angr 
CMD su - pwndevil

# create a cool looking terminal 
WORKDIR /tmp
RUN git clone https://github.com/mahaloz/pwnbox.git  
WORKDIR /tmp/pwnbox 
RUN git checkout master
WORKDIR /home/angr
RUN cp /tmp/pwnbox/enviornment/bash/.bashrc /home/angr/ && \
    cp /tmp/pwnbox/enviornment/bash/.bash_prompt /home/angr/ && \
    printf '\nworkon angr\n' >> /home/angr/.bashrc

# setup vim to be awesome
RUN cp /tmp/pwnbox/enviornment/vim/.vimrc /home/angr/ && \
    mkdir ~/.vim/ && \
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
    echo | echo | vim +PluginInstall +qall &>/dev/null 
    #sleep 50
    
    #python3 ~/.vim/bundle/youcompleteme/install.py --all
    #echo | echo | vim +PluginInstall +qall &>/dev/null 
    #/bin/bash /tmp/pwnbox/enviornment/vim/install.sh 
    