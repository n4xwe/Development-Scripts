#!/bin/sh
#install HamLib(3.3)
#N4XWE 6-26-2020
#Visit http://www.iquadlabs.com


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install git cmake build-essential libusb-1.0-0-dev libltdl-dev libreadline-dev libsndfile1-dev \
g++ libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
libusb-1.0-0 libgd-dev libhamlib-utils libsamplerate0 libsamplerate0-dev libsigx-2.0-dev libsigc++-1.2-dev libpopt-dev \
tcl8.5-dev libasound2-dev libgd-dev alsa-utils libgcrypt20-dev libpopt-dev libfltk1.3-dev libpng++-dev \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml \
python3-click python3-click-plugins libportaudio-dev libpulse-dev libportaudiocpp0 ||
	{ echo 'Dependency installation failed'; exit 1;}

#Create a unique directory for the QSSTV compile and make it the current directory
mkdir ~/src/HAMLIB && cd ~/src/HAMLIB

#Download the HamLib 3.3 source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/3.3/hamlib-3.3.tar.gz ||
  { echo 'Unable to download the HamLib source code file'; exit 1; }
  
#Extract the HamLib source code files
tar -xvzf hamlib-3.3.tar.gz

#Make the directory containing the uncompressed HamLib source code the current directory
cd ~/src/HAMLIB/hamlib-3.3

#Configure the Makefile for the HamLib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the HamLib libraries
make && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the HamLib library files
sudo ldconfig


