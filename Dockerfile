FROM ubuntu:18.04 
MAINTAINER zbasque@asu.edu 

# ----- Setup Enviornment ----- #
# get basics
USER root 
RUN apt-get update && apt-get install -y sudo sshfs bsdutils python3-dev \
                            libpq-dev pkg-config zlib1g-dev libtool libtool-bin wget automake autoconf coreutils bison libacl1-dev \
                            qemu-user qemu-kvm socat \
                            postgresql-client nasm binutils-multiarch llvm clang \
                            libpq-dev parallel libgraphviz-dev \
                            build-essential libxml2-dev libxslt1-dev git \
                            libffi-dev cmake libreadline-dev libtool         

# rename main user to pwndevil
USER root 
RUN useradd -s /bin/bash -m pwndevil 
CMD su - pwndevil

# create a cool looking terminal 
WORKDIR /tmp
RUN git clone https://github.com/mahaloz/pwnbox.git  
WORKDIR /tmp/pwnbox 
RUN git checkout master
WORKDIR /home/pwndevil 
RUN cp /tmp/pwnbox/enviornment/bash/.bashrc /home/pwndevil/ && \
    cp /tmp/pwnbox/enviornment/bash/.bash_prompt /home/pwndevil/

# install sudo
RUN apt-get update && \
    apt-get install sudo -y && \ 
    echo "pwndevil ALL=NOPASSWD: ALL" > /etc/sudoers.d/pwndevil

# install ipython3 
RUN apt-get install ipython3 -y

# install angr
RUN apt-get install python3-pip -y

USER pwndevil
RUN pip3 install --user angr 

# install CTF-Tools reqs
USER root 
RUN apt-get install -y build-essential libtool g++ gcc \
    texinfo curl wget automake autoconf python python-dev git subversion \
    unzip virtualenvwrapper sudo git virtualenvwrapper ca-certificates

# setup vim to be awesome
RUN apt-get install vim -y 

USER pwndevil 
RUN mkdir /home/pwndevil/.vim/ && \
    cp /tmp/pwnbox/enviornment/vim/.vimrc /home/pwndevil/.vimrc 
RUN  git clone https://github.com/VundleVim/Vundle.vim.git /home/pwndevil/.vim/bundle/Vundle.vim 
#    vim -E -u NONE -S /home/angr/.vim/vundle.vim +PluginInstall +qall > /dev/null
#    printf '\nworkon angr\n' >> /home/angr/.bashrc 
#    #python3 /home/angr/.vim/bundle/youcompleteme/install.py --all
RUN  vim +PluginInstall +qall &>/dev/null 
#    #/bin/bash /tmp/pwnbox/enviornment/vim/install.sh 


# ----- RE Tools ----- #
USER root

# install gdb & gef 
RUN apt-get update && \
    apt-get install gdb -y && \
    wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh 

# install radare2
WORKDIR /tmp 
RUN git clone https://github.com/radare/radare2.git && \
    ./radare2/sys/install.sh

# install wine & winedbg
RUN apt-get update && \
    apt-get install wine-stable -y 


# ----- PWN Tools ----- #
USER pwndevil 

# install pwntools3
RUN pip3 install --user pwntools 

# install ropper 3 
RUN pip3 install ropper

# install ROPGadget2 & 3 
RUN pip3 install --user ROPGadget     


# ----- Crypto Tools ----- #

# install sage and numpy
RUN pip3 install --user sagemath numpy 


# ----- CTF Tools @zardus ----- #

# get the ctf tools repo 
RUN cd /home/pwndevil/ && git clone https://github.com/zardus/ctf-tools && \
    cd ctf-tools

# ----- Extra Tools ----- #
USER root
RUN apt-get update && apt-get install -y \
    tmux \
    xclip 

# ----- Terminator Tmux ----- #
RUN mv /tmp/pwnbox/enviornment/tmux/.tmux.conf /home/pwndevil/.tmux.conf  
RUN mv /tmp/pwnbox/enviornment/tmux/.tmux /home/pwndevil/.tmux

# sick sparky and team logo print!  
RUN echo "echo 'pwnbox is brought to you by: \n'" >> /home/pwndevil/.bashrc 
RUN echo 'base64 -d <<< "IF8gIChgLScpICAgICAuLT4gICA8LS4gKGAtJylfICBfKGAtJykgICAgKGAtJykgIF8gICAgICAoYC0nKSAgXyAgICAgICAgICAgICAgKGAtJykuLT4gCiBcLS4oT08gKSAoYChgLScpL2ApICAgXCggT08pICkoIChPTyApLi0+ICggT08pLi0vICAgICBfKE9PICkgKF8pICAgICAgPC0uICAgICggT08pXyAgIAogXy4nICAgIFwsLWAoIE9PKS4nLCwtLS4vICwtLS8gIFwgICAgLidfICgsLS0tLS0tLiwtLS4oXy8sLS5cICwtKGAtJyksLS0uICkgIChfKS0tXF8pICAKKF8uLi4tLScnfCAgfFwgIHwgIHx8ICAgXCB8ICB8ICAnYCctLi5fXykgfCAgLi0tLSdcICAgXCAvIChfLyB8ICggT08pfCAgKGAtJykvICAgIF8gLyAgCnwgIHxfLicgfHwgIHwgJy58ICB8fCAgLiAnfCAgfCkgfCAgfCAgJyB8KHwgICctLS4gIFwgICAvICAgLyAgfCAgfCAgKXwgIHxPTyApXF8uLmAtLS4gIAp8ICAuX19fLid8ICB8LicufCAgfHwgIHxcICAgIHwgIHwgIHwgIC8gOiB8ICAuLS0nIF8gXCAgICAgL18pKHwgIHxfLyh8ICAnX18gfC4tLl8pICAgXCAKfCAgfCAgICAgfCAgICwnLiAgIHx8ICB8IFwgICB8ICB8ICAnLScgIC8gfCAgYC0tLS5cLSdcICAgLyAgICB8ICB8Jy0+fCAgICAgfCdcICAgICAgIC8gCmAtLScgICAgIGAtLScgICAnLS0nYC0tJyAgYC0tJyAgYC0tLS0tLScgIGAtLS0tLS0nICAgIGAtJyAgICAgYC0tJyAgIGAtLS0tLScgIGAtLS0tLScg"' >> /home/pwndevil/.bashrc 
RUN echo "echo '\n\n'" >> /home/pwndevil/.bashrc 
RUN echo 'base64 -d <<< "ICAgICAgICAgICAgICYmICAgICAgICAgICAgICAKICAgICAgICAmJiAmJiYmJiAgICAgICAgICAgICAKICAgICAgICAmJiYmJiYmLCwmICAgICAgICAgICAKICAgICAgICAgJiYsLCYsLCYsJiAgICAgICAgICAKICAgICAmJiYgJiYsLCwsLCwsLCYgICAgICAgICAKICAgICYmJiYmJiYmLCwsLCYmJiwmICAgICAgICAKICAmJiYmJiYmJiYsLC4mJiYmJiwmICAgICAgICAKICAgICYmJiAgJiYsLCwsLCYsLCYmICAgICAgICAKJiYgICYmJiYmICYmJiYmJiwmJiYmICAgICAgICAKJiYmJiAgJiYsJiYmJiYmJiYmJiYmICAgICAmJiAKICAgICYmJiYmJiwmJiYmJiYmJiYmJiYmICYmJiAKICAgICYmJiAmJiYmLCYmJiYmJiYmJiYmJiYmJiAKICAmJiYmJiAgJiYmJiYsJiYmJiYmJiYmJiYmJiAKICYmJiAmJiYmJiYmJiAgJiwgJiYmICYmJiYmICAKICAgICAmJiYmJiAgICAgICYmJiYgICAgJiYgICAKICAgICAgICAgICAgICAgICAmJiwsICwsJiAgICAKICAgICAgICAgICAgICAgICAgICYsLCYgICwsICAKICAgICAgICAgICAgICAgICAgICwsICYsJiAgICYKICAgICAgICAgICAgICAgICAgICAmLCAgJiwmICAKICAgICAgICAgICAgICAgICAgICAgICwgICAmJg=="' >> /home/pwndevil/.bashrc 
RUN echo "\necho '\n\n'" >> /home/pwndevil/.bashrc 


