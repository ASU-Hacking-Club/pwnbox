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

# install sudo
RUN apt-get update && \
    apt-get install sudo -y && \ 
    echo "pwndevil ALL=NOPASSWD: ALL" > /etc/sudoers.d/pwndevil

# install ipython2
RUN apt-get update && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python2 get-pip.py && \
    pip2 install ipython   

# setup vim to be awesome
#RUN mkdir /home/angr/.vim/ && \
#    cp /tmp/pwnbox/enviornment/vim/.vimrc /home/angr/.vim/vundle.vim && \
#    git clone https://github.com/VundleVim/Vundle.vim.git /home/angr/.vim/bundle/Vundle.vim && \
#    vim -E -u NONE -S /home/angr/.vim/vundle.vim +PluginInstall +qall > /dev/null && \
#    printf '\nworkon angr\n' >> /home/angr/.bashrc 
#    #python3 /home/angr/.vim/bundle/youcompleteme/install.py --all
#    #echo | echo | vim +PluginInstall +qall &>/dev/null 
#    #/bin/bash /tmp/pwnbox/enviornment/vim/install.sh 


# ----- RE Tools ----- #
USER root

# install gdb & peda 
RUN apt-get update && \
    apt-get install gdb -y && \
    git clone https://github.com/longld/peda.git /home/angr/peda && \
    echo "source /home/angr/peda/peda.py" >> /home/angr/.gdbinit

# install radare2
WORKDIR /tmp 
RUN git clone https://github.com/radare/radare2.git && \
    ./radare2/sys/install.sh

# install wine & winedbg
RUN apt-get update && \
    apt-get install wine-stable -y 


# ----- PWN Tools ----- #

# install pwntools2 & 3
RUN apt-get install python-dev -y 
RUN pip2 install pwntools && \
    pip3 install pwntools 

# install ropper 3 
RUN pip3 install ropper

# install ROPGadget2 & 3 
RUN pip2 install ROPGadget && \
    pip3 install ROPGadget     


# ----- Crypto Tools ----- #

# install sage and numpy
RUN pip3 install sagemath numpy 


# ----- Extra Tools ----- #
# sick sparky and team logo print!  
RUN echo "echo 'pwnbox is brought to you by: \n'" >> /home/angr/.bashrc 
RUN echo 'base64 -d <<< "IF8gIChgLScpICAgICAuLT4gICA8LS4gKGAtJylfICBfKGAtJykgICAgKGAtJykgIF8gICAgICAoYC0nKSAgXyAgICAgICAgICAgICAgKGAtJykuLT4gCiBcLS4oT08gKSAoYChgLScpL2ApICAgXCggT08pICkoIChPTyApLi0+ICggT08pLi0vICAgICBfKE9PICkgKF8pICAgICAgPC0uICAgICggT08pXyAgIAogXy4nICAgIFwsLWAoIE9PKS4nLCwtLS4vICwtLS8gIFwgICAgLidfICgsLS0tLS0tLiwtLS4oXy8sLS5cICwtKGAtJyksLS0uICkgIChfKS0tXF8pICAKKF8uLi4tLScnfCAgfFwgIHwgIHx8ICAgXCB8ICB8ICAnYCctLi5fXykgfCAgLi0tLSdcICAgXCAvIChfLyB8ICggT08pfCAgKGAtJykvICAgIF8gLyAgCnwgIHxfLicgfHwgIHwgJy58ICB8fCAgLiAnfCAgfCkgfCAgfCAgJyB8KHwgICctLS4gIFwgICAvICAgLyAgfCAgfCAgKXwgIHxPTyApXF8uLmAtLS4gIAp8ICAuX19fLid8ICB8LicufCAgfHwgIHxcICAgIHwgIHwgIHwgIC8gOiB8ICAuLS0nIF8gXCAgICAgL18pKHwgIHxfLyh8ICAnX18gfC4tLl8pICAgXCAKfCAgfCAgICAgfCAgICwnLiAgIHx8ICB8IFwgICB8ICB8ICAnLScgIC8gfCAgYC0tLS5cLSdcICAgLyAgICB8ICB8Jy0+fCAgICAgfCdcICAgICAgIC8gCmAtLScgICAgIGAtLScgICAnLS0nYC0tJyAgYC0tJyAgYC0tLS0tLScgIGAtLS0tLS0nICAgIGAtJyAgICAgYC0tJyAgIGAtLS0tLScgIGAtLS0tLScg"' >> /home/angr/.bashrc 
RUN echo "echo '\n\n'" >> /home/angr/.bashrc 
RUN echo 'base64 -d <<< "ICAgICAgICAgICAgICYmICAgICAgICAgICAgICAKICAgICAgICAmJiAmJiYmJiAgICAgICAgICAgICAKICAgICAgICAmJiYmJiYmLCwmICAgICAgICAgICAKICAgICAgICAgJiYsLCYsLCYsJiAgICAgICAgICAKICAgICAmJiYgJiYsLCwsLCwsLCYgICAgICAgICAKICAgICYmJiYmJiYmLCwsLCYmJiwmICAgICAgICAKICAmJiYmJiYmJiYsLC4mJiYmJiwmICAgICAgICAKICAgICYmJiAgJiYsLCwsLCYsLCYmICAgICAgICAKJiYgICYmJiYmICYmJiYmJiwmJiYmICAgICAgICAKJiYmJiAgJiYsJiYmJiYmJiYmJiYmICAgICAmJiAKICAgICYmJiYmJiwmJiYmJiYmJiYmJiYmICYmJiAKICAgICYmJiAmJiYmLCYmJiYmJiYmJiYmJiYmJiAKICAmJiYmJiAgJiYmJiYsJiYmJiYmJiYmJiYmJiAKICYmJiAmJiYmJiYmJiAgJiwgJiYmICYmJiYmICAKICAgICAmJiYmJiAgICAgICYmJiYgICAgJiYgICAKICAgICAgICAgICAgICAgICAmJiwsICwsJiAgICAKICAgICAgICAgICAgICAgICAgICYsLCYgICwsICAKICAgICAgICAgICAgICAgICAgICwsICYsJiAgICYKICAgICAgICAgICAgICAgICAgICAmLCAgJiwmICAKICAgICAgICAgICAgICAgICAgICAgICwgICAmJg=="' >> /home/angr/.bashrc 
RUN echo "\necho '\n\n'" >> /home/angr/.bashrc 
