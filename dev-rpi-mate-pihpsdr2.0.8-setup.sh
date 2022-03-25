#!/bin/sh
#install PiHPSDR(2.0.8rc) with wdsp(1.18)
#N4XWE 3-25-2022
#Test Compiled on Ubuntu MATE 20.04 64-bit

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Download and install the dependencies
sudo apt install -y git git-core libfftw3-dev libgtk-3-dev libpulse-dev libasound2-dev \
libpulse-mainloop-glib0 libusb-1.0-0-dev libi2c-dev libgpiod-dev gpiod rpi.gpio-common ||
  { echo 'Dependency installation failed'; exit 1; }

#Create a unique directory for the PiHPSDR compile and make it the current directory
mkdir -p ~/src/PIHPSDR && cd ~/src/PIHPSDR

#Clone the most recent version of the wdsp source code from github
git clone https://github.com/g0orx/wdsp ||
  { echo 'Unable to download the wdsp source code file'; exit 1; }
 
#Change the directory containing the wdsp source code to the current directory
cd ~/src/PIHPSDR/wdsp

#Compile and install the wdsp libraries
make clean && make -j 3 && sudo make install ||
  { echo 'Unable to install the wdsp Libraries'; exit 1; }
  
#Make the unique directory previously created for the compile the current directory 
cd ~/src/PIHPSDR

#Clone the most recent version of the PiHPSDR source code from github
git clone https://github.com/g0orx/pihpsdr

#Make the directory containing the pihpsdr source code the current directory
cd ~/src/PIHPSDR/pihpsdr

#Copy the wdsp library files to the release directory
cp ~/src/PIHPSDR/wdsp/libwdsp.so ~/src/PIHPSDR/pihpsdr/release

#Compile and install the PiHPSDR souce code
make -j 3 && make release && sudo make install

#Copy the hpsdr.png icon to a system directory
sudo cp ~/src/PIHPSDR/pihpsdr/release/pihpsdr/hpsdr.png /usr/local/share

#Add a PiHPSDR icon to the Desktop
echo "[Desktop Entry]
Name=pihpsdr
Comment=PiHPSDR Console
Exec=/usr/local/bin/pihpsdr
TryExec=usr/local/bin/pihpsdr
Icon=/usr/local/share/hpsdr.png
Terminal=false
Type=Application
StartupNotify=true" ||
   { echo 'Unable to setup the PiHPSDR icon'; exit 1;}
   


#If the Start button appears in the Discovery window, left click on it to start PiHPSDR.  If the Subnet! 
#notification appears, right click on the Network icon in the upper right corner of the desktop.  From 
#the menu that appears select "Wireless & Wired Network Settings" From the Network Preferences menu select
#Configure: interface eth0, check the box labled "Disable IPv6" in the IPv4 box insert an IP address
#that is on the Subnet of the IP address of the IQ2 (For example 192.168.1.10 for an IQ2 configured with
#the standard 192.168.1.25, no DHCP setting). Restart PiHPSDR. The Start button should appear the next time the
#PiHPSDR Discovery menu appears.

#When PiHPSDR starts for the first time it generates a wisdom file, which takes a few minutes, and a configuration file named [The MAC address of the RPi].props

#Shut down PiHPSDR and edit the [The MAC address of the RPi].props file to:
#change receivers=2 to receivers=1
#change receiver.1.sample_rate=48000 to =384000

#Start PiHPSDR.


