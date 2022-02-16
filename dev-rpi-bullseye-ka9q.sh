
#!/bin/sh
#install ka9q-radio
#N4XWE 2-15-2022
#Compiled on RaspiOS-bullseye dtd 2022-1-28 32-bit


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install git cmake build-essential libusb-1.0-0-dev libfftw3-dev \
libbsd-dev libopus-dev libasound2-dev libncurses5-dev libncursesw5-dev \
libattr1-dev portaudio19-dev libhackrf-dev libairspy-dev libairspyhf-dev \
libavahi-client-dev rcs
	{ echo 'Dependency installation failed'; exit 1;}
  
#Create a unique directory for the ka9q-radio compile and make it the current directory
mkdir -p ~/src/KA9Q && cd ~/src/KA9Q

#Download the ka9q-radio source code from ka9q.net
wget www.ka9q.net/ka9q-radio.tar.xz ||
  { echo 'Unable to download the KA9Q-radio source code file'; exit 1; }
  
#Extract the ka9q-radio source code files
tar xvf ka9q-radio.tar.xz

#Make the directory containing the uncompressed KA9Q-radio source code the current directory
cd ~/src/KA9Q/ka9q-radio



#Configure the Makefile for the Hamlib compile
./configure --prefix=/usr/local --enable-static

#Compile and install the Hamlib libraries
make -j3 && sudo make install ||
  { echo 'Unable to install the HamLib Libraries'; exit 1; }

#Link the Hamlib library files
sudo ldconfig

#Install an Fldigi icon on the RPi desktop
echo "[Desktop Entry]
Name=Fldigi
GenericName=Amateur Radio Digital Modem
Comment=Amateur Radio Sound Card Communications
Exec=/usr/local/bin/fldigi
Icon=/usr/local/share/pixmaps/fldigi.xpm
Terminal=false
Type=Application
Categories=Network;HamRadio;" > /home/pi/Desktop/fldigi.desktop ||
   { echo 'Unable to setup the fldigi desktop icon'; exit 1;}
