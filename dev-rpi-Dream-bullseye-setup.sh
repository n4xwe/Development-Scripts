#!/bin/bash
#install Dream(2.2.1) with FAAD2(2.8.8) and FAAC(1.30)
#N4XWE 11-28-2021
#Compiled on RaspiOS-bullseye dtd 2021-10-30 32-bit

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Install the required dependencies
sudo apt install -y libqwt-qt5-6 libqwt-qt5-dev g++ make libsysfs-dev automake \
apt-utils libqt5webkit5-dev libpcap-dev libgps28 libgps-dev libfftw3-dev \
libasound2-dev libspeex1 libspeexdsp1 libtool libtool-bin libqt5svg5 libqt5svg5-dev \
libpulse-dev qt5-qmake libpcap-dev libspeexdsp-dev subversion

sudo apt remove libfaad2 -y

#Create a unique directory for the DREAM compile and make it the current directory
mkdir -p ~/src/DREAM && cd ~/src/DREAM

#Download the faad2 library source code from Sourceforge
wget https://sourceforge.net/projects/faac/files/faad2-src/faad2-2.8.0/faad2-2.8.8.tar.gz  ||
  { echo 'Unable to download the faad2 source code'; exit 1; }

#Extract the faad2 source code files
tar zxf faad2-2.8.8.tar.gz

#Change the directory containing the faad2 source code to the current directory
cd faad2-2.8.8

#Configure the faad2 Makefile
./configure --enable-shared --with-drm --without-mpeg4ip --disable-static --without-xmms

#Compile the faad2 libraries with three CPU cores
make -j3

#Install the faad2 libraries
sudo make install

#Link the faad2 library files
sudo ldconfig

#Move the current directory up one level to ~/src/Dream
cd ~/src/DREAM

#Download the faac library source code from Sourceforge
wget https://sourceforge.net/projects/faac/files/faac-src/faac-1.30/faac-1_30.tar.gz ||
  { echo 'Unable to download the faac source code'; exit 1; }

#Extract the faac source code files
tar zxf faac-1_30.tar.gz

#Change the directory containing the faac source code to the current directory
cd faac-1_30

#Bootstrap build the
./bootstrap

#Configure the faac Makefile
./configure --with-pic --enable-shared --without-mp4v2 --enable-drm

#Compile the faac libraries with three CPU cores
make -j3

#Link the faac library files library files
sudo ldconfig

#Move the current directory up one level to ~/src/DREAM
cd ~/src/DREAM

#Download the modified Dream 2.2.1 source code from Sourceforge
svn checkout -r1375 https://svn.code.sf.net/p/drm/code/branches/dream-mjf ||
  { echo 'Unable to download the Dream 2.2.1 source code'; exit 1; }
  
#Change the directory containing the Dream source code to the current directory
cd dream-mjf

#Configure the Dream Makefile
qmake CONFIG+=alsa CONFIG+=sound

#Compile the Dream source code with three CPU cores
make -j3

#Copy the Dream executable file to the /usr/local/bin directory
sudo cp dream /usr/local/bin/dream

#Copy the Dream icon to the /usr/share/icons directory
sudo cp src/GUI-QT/res/MainIcon.svg /usr/share/icons/dream.svg

#Add an icon to launch Dream to the Desktop
echo "[Desktop Entry]
Name=Dream
GenericName=DRM Receiver
Comment=Software Digital Radio Mondiale Receiver
Exec=/usr/local/bin/dream -I pulse -O pulse
Icon=/usr/share/icons/dream.svg
Terminal=false
Type=Application
Categories=Other" > ~/Desktop/dream.desktop ||
   { echo 'Unable to setup Dream icon'; exit 1;}

