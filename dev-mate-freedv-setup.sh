#!/bin/sh
# install freedv
#N4XWE 6-21-2020
#Visit http://www.iquadlabs.com

#Update the OS and the RPI firmware
sudo apt -y update && sudo apt -y upgrade

#Download and install the required build dependencies
sudo apt -y install cmake subversion libwxgtk3.0-gtk3-dev portaudio19-dev \
libusb-1.0-0-dev libsamplerate0-dev libasound2-dev libao-dev libgsm1-dev \
libsndfile1-dev libjpeg9-dev libxft-dev libxinerama-dev libxcursor-dev \
libspeex-dev libspeexdsp-dev libreadline-dev ||
	{ echo 'Dependency download failed'; exit 1;}

#Create a 2GB swapfile
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#Set the compiler optimization flags
export CXXFLAGS='-O2 -march=native -mtune=native'
export CFLAGS='-O2 -march=native -mtune=native'

#Make a directory for the FreeDV compile and make it the current directory
mkdir -p ~/src/FreeDV && cd ~/src/FreeDV || 
	{ echo 'Unable to create the FreeDV dir'; exit 1; }
	
#Download the HamLib source code from Sourceforge
wget -N https://sourceforge.net/projects/hamlib/files/hamlib/3.3/hamlib-3.3.tar.gz ||
  { echo 'Unable to download the HamLib file'; exit 1; }

#Extract the HamLib source tarball and make it the current directory
tar -xvzf hamlib* && cd hamlib*

#Configure the HamLib makefile
./configure --prefix=/usr/local --enable-static

#Compile the source code and link the resulting libraries
make && sudo make install && sudo ldconfig ||
  { echo 'Unable to install HamLib'; exit 1; }

#Make the current directory the bottom directory 
cd ~/src/FreeDV

#Download the codec2 source code from Github and make codec2 the current directory
git clone https://github.com/drowe67/codec2.git && cd codec2 ||
  { echo 'Unable to download codec2'; exit 1; }

#Make an indirect build directory and change it to the current directory
mkdir build && cd build

#Configure cmake
cmake  .. 

#Compile the Codec2 source code
make ||
  { echo 'Unable to compile Codec2'; exit 1; }
  
#Make the FreeDV directory the current directory 
cd ~/src/FreeDV

#Download the LPCNet source code
git clone https://github.com/drowe67/LPCNet && cd LPCNet

#Make an indirect build directory and change it to the current directory
mkdir build && cd build

#Configure the cmake file
cmake -DCODEC2_BUILD_DIR=~/src/FreeDV/codec2/build ../ 

#Compile the LPCNet source
make ||
  { echo 'Unable to make LPCNet'; exit 1; }

#Make the Codec2 compile directory the current directory
cd ~/src/FreeDV/codec2/build

#sudo cp /src/FreeDV/LPCNet/build/lpcnetfreedvConfig.cmake /usr/local/include

#Remove the uneccessary files
rm -Rf *

#Configure the cmake file
cmake -DLPCNET_BUILD_DIR=~/src/FreeDV/LPCNet/build ..

#Remake Codec2 with LPCNet and install and link the libraries
make && sudo make install && sudo ldconfig ||
  { echo 'Unable to Recompile Codec2 with LPCNet'; exit 1; }

#Make the current directory the bottom directory 
cd ~/src/FreeDV

#Download the FreeDV source code from Github and make freedv-gui the current directory
git clone https://github.com/drowe67/freedv-gui && cd freedv-gui ||
  { echo 'Unable to download the freedv-gui file'; exit 1; }

#Make an indirect build directory and change it to the current directory
mkdir build && cd build

#Configure the cmake file
cmake -DCMAKE_BUILD_TYPE=Release ../ 

#Compile the source code and the install the binaries
make && sudo make install ||
  { echo 'Unable to install FreeDV'; exit 1; }

#Add ubuntu to the dialout user group
sudo usermod -a -G dialout ubuntu

echo "[Desktop Entry]
Name=FreeDV
GenericName=Amateur Radio Digital Voice
Comment=FreeDV Digital Voice
Exec=/usr/local/bin/freedv
Icon=freedv
Terminal=false
Type=Application
Categories=Other" > /home/pi/Desktop/freedv.desktop ||
   { echo 'Unable to setup FreeDV icon'; exit 1;}
