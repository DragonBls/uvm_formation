#!/bin/bash

# recent git
sudo yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm
sudo yum -y install git
sudo yum -y install tig

sudo yum -y install epel-release
sudo yum -y install fuse-sshfs
sudo yum -y install gcc clang libcxx libstdc++-static gcc-c++
sudo yum -y install nodejs npm
sudo yum -y install autoconf automake
sudo yum -y install htop
sudo yum -y install xfce4-terminal
sudo yum -y install ksh
sudo yum -y install the_silver_searcher

# ripgrep
sudo yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo
sudo yum -y install ripgrep

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# python3.8
sudo yum -y install gcc openssl-devel bzip2-devel libffi-devel
mkdir -p ~/src
cd ~/src
curl -O https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz
tar -xzf Python-3.8.1.tgz
cd Python-3.8.1/
./configure --enable-optimizations
sudo make altinstall

# ctags
mkdir -p ~/src
cd ~/src
git clone https://github.com/universal-ctags/ctags.git
cd ctags
./autogen.sh
./configure --prefix=/usr
make
sudo make install

ssh-keygen
