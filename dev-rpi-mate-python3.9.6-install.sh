#!/bin/sh
#install Python 3.9.6
#N4XWE 3-26-2022
#Visit http://www.iquadlabs.com


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install git libreadline-dev libbz2-dev tcl-dev libncurses-dev libsqlite3-dev  \
liblzma-dev libgdbm-dev libhashkit-dev checkinstall tk-dev libssl-dev openssl libffi-dev \
uuid-dev libncurses*-dev


#Create a unique directory for the GNU Radio compile and make it the current directory
mkdir -p ~/src/PYTHON && cd ~/src/PYTHON

#download the Python Source code from the python.org repository
wget https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tgz ||
     { echo 'Unable to download the Python source code file'; exit 1; }
  
#Extract the Python source code files
tar -xvzf Python-3.9.6.tgz

#Make the directory containing the uncompressed Python source code the current directory
cd ~/src/PYTHON/Python-3.9.6

#Configure the Makefile for the Python compile
./configure --enable-optimizations --with-ensurepip=install

#Compile and install the Python packages
make -j 3 && sudo make altinstall ||
  { echo 'Unable to install the Python Packages'; exit 1; }

sudo rm /usr/bin/python
sudo ln -s /usr/local/bin/python3.9 /usr/bin/python
