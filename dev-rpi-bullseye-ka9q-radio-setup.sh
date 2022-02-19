
#!/bin/sh
#install ka9q-radio
#KV0S and N4XWE 2-19-2022 (Revision A)
#Compiled on RaspiOS-bullseye dtd 2022-1-28 32-bit


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt -y upgrade

#Add all of the dependencies
sudo apt -y install git cmake build-essential libusb-1.0-0-dev libfftw3-dev \
libbsd-dev libopus-dev libasound2-dev libncurses5-dev libncursesw5-dev \
libattr1-dev portaudio19-dev libhackrf-dev libairspy-dev libairspyhf-dev \
libavahi-client-dev rcs ||
	{ echo 'Dependency installation failed'; exit 1;}
  
#Create a unique directory for the ka9q-radio compile and make it the current directory
mkdir -p ~/src/KA9Q && cd ~/src/KA9Q

#Download the ka9q-radio source code from ka9q.net
wget www.ka9q.net/ka9q-radio.tar.xz ||
  { echo 'Unable to download the KA9Q-radio source code'; exit 1; }
  
#Extract the ka9q-radio source code files
tar xvf ka9q-radio.tar.xz

#Make the directory containing the uncompressed ka9q-radio source code the current directory
cd ~/src/KA9Q/ka9q-radio

#Create a directory for the source code files that will be updated by the Revision Control System
mkdir -p ~/src/KA9Q/ka9q-radio/src && cd ~/src/KA9Q/ka9q-radio/src

#Do a check out of the revised source code files
co ../RCS/*,v

#Compile the ka9q-radio souce code
make -f Makefile.linux all

#Install the compiled ka9q-radio souce code
sudo make -f Makefile.linux install ||
  { echo 'Unable to install ka9q-radio'; exit 1; }
  
#Create a directory for the wisdom file in the /etc/fftw directory
sudo mkdir -p  /etc/fftw

#Create the fftw3 wisdom file
sudo fftwf-wisdom -v -n -o /etc/fftw/wisdom 128 256 512 1024

#Copy the fftw3 wisdom file to /var/lib/ka9q-radio
sudo cp /etc/fftw/wisdom /var/lib/ka9q-radio



