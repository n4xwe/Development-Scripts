#!/bin/sh
#install wsjt-x (2.2.2)
#N4XWE 12-05-2020
#Visit http://www.iquadlabs.com

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Check to see if a previous version of HamLib has been installed
#Remove if the answer is yes
sudo apt remove libhamlib2 -y

#Add all of the dependencies
sudo apt install -y git cmake automake libtool \
asciidoctor asciidoc gfortran subversion libwxgtk3.0-gtk3-dev \
libusb-1.0-0-dev portaudio19-dev libsamplerate0-dev \
libasound2-dev libao-dev libfftw3-dev libgsm1-dev \
libjpeg9-dev libxft-dev libxinerama-dev libxcursor-dev \
libboost-all-dev libqt5multimedia5 libqt5multimedia5-plugins \
libqt5multimediaquick5 libreadline-dev libqt5multimediawidgets5 \
libqt5serialport5-dev libqt5svg5-dev libqt5widgets5 \
libqt5sql5-sqlite libqwt-qt5-dev libsndfile1-dev \
libudev-dev qtmultimedia5-dev texinfo xsltproc swig \
qttools5-dev qttools5-dev-tools qtbase5-dev-tools ||
	{ echo 'Dependency installation failed'; exit 1; }

#Add and enable a 2GB Swapfile
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#Create a unique directory for the WSJT-X compile and make it the current directory
mkdir -p ~/src/wsjtx && cd ~/src/wsjtx

#Download the HamLib 3.3 source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/3.3/hamlib-3.3.tar.gz ||
  { echo 'Unable to download the HamLib source code file'; exit 1; }
  
#Extract the HamLib source code files
tar -xvzf hamlib-3.3.tar.gz

#Make the directory containing the uncompressed HamLib source code the current directory
cd ~/src/wsjtx/hamlib-3.3

#Configure the Makefile for the HamLib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the HamLib libraries
make && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the HamLib library files
sudo ldconfig

#Set the CPU optimization Flags for compiling the WSJT-X source code
export CXXFLAGS='-O2 -march=native -mtune=native'
export CFLAGS='-O2 -march=native -mtune=native'

#Make the unique directory previously created for the compile the current directory 
cd ~/src/wsjtx

#Download the WSJT-X source code from Sourceforge
wget -N https://sourceforge.net/projects/wsjt/files/wsjtx-2.2.2/wsjtx-2.2.2.tgz ||
  { echo 'Unable to download the WSJT-X source code file'; exit 1; }

#Extract the WSJT-X source code files
tar -zxvf wsjtx-2.2.2.tgz

#Create a directory for an indirect build of WSJT-X and make it the current directory
mkdir -p ~/src/wsjtx/wsjtx-2.2.2/build && cd ~/src/wsjtx/wsjtx-2.2.2/build 

#Configure the Makefile for the WSJT-X compile
cmake ..

#Compile and install the executable and support files for WSJT-X
make && sudo make install ||
  { echo 'Unable to install WSJT-X'; exit 1; }

#Add the user pi to the dialout group
sudo usermod -a -G dialout ubuntu
