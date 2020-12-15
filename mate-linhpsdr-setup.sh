#!/bin/sh
#install LinHPSDR
#N4XWE 7-03-2020
#Visit http://www.iquadlabs.com

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt -y update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install git cmake build-essential libusb-1.0-0-dev libfftw3-dev \
libpulse-dev libasound2-dev libsoundio-dev libgtk-3-dev libsoapysdr-dev checkinstall \
libtool libjack-jackd2-dev ||
  { echo 'Dependency installation failed'; exit 1; }

#Add and enable a 2GB Swapfile
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#Create a unique directory for the LinHPSDR compile and make it the current directory
mkdir -p ~/src/LINHPSDR && cd ~/src/LINHPSDR

#Download the wdsp source code from Github
git clone https://github.com/g0orx/wdsp.git  ||
  { echo 'Unable to download wdsp'; exit 1; }

#Make the directory containing the uncompressed wdsp source code the current directory
cd ~/src/LINHPSDR/wdsp

#Compile and install the wdsp libraries
make && sudo make install ||
   { echo 'Unable to install wdsp'; exit 1; }

#Link the wdsp library files
sudo ldconfig

#Make the unique directory previously created for the compile the current directory
cd ~/src/LINHPSDR

#Download the LinHPSDR source code from Github
git clone https://github.com/g0orx/linhpsdr.git ||
  { echo 'Unable to download LinHPSDR'; exit 1; }

#Make the directory containing the uncompressed LinHPSDR source code the current directory
cd ~/src/LINHPSDR/linhpsdr

#Compile and install LinHPSDR
make && sudo make install ||
  { echo 'Unable to install LinHPSDR'; exit 1; }
  

