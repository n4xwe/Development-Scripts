#!/bin/sh
#install GNU Radio(3.9) w/grnet w/digital_rf
#N4XWE 2-13-2021
#Compiled on Raspberry Pi OS 1-11-2021 32-bit

#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Add the compile dependencies
sudo apt -y install git cmake make build-essential libusb-1.0-0-dev libltdl-dev libreadline-dev libsndfile1-dev zlib1g-dev libpcap-dev \
g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev libstdc++-8-dev-armhf-cross \
libusb-1.0-0 doxygen-latex libhamlib-utils libsamplerate0 libsamplerate0-dev libsigx-2.0-dev libsigc++-2.0-dev libpopt-dev libhdf5-dev \
tcl-dev python3-gi-cairo python3-cairo-dev python-cairo libspeex-dev libasound2-dev alsa-utils libgcrypt20-dev libgsm1-dev python-dateutil \
python3-pygccxml libpopt-dev libfltk1.3-dev libpng++-dev libghc-cairo-dev libghc-cairo-dev python-cairo-dev liborc-0.4-dev python-setuptools python-tz \
libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml python3-pybind11 python3-h5py \
python3-click python3-click-plugins portaudio19-dev libpulse-dev libportaudiocpp0 libcairo2-dev python3-dev python3-matplotlib python-six \
libgirepository1.0-dev libcppunit-dev python3-watchdog libgmp-dev swig libgsl-dev python3-zmq python3-scipy libpthread-stubs0-dev libusb-1.0-0 \
libusb-1.0-0-dev libudev-dev python3-setuptools python-docutils liborc-0.4-0 liborc-0.4-dev python3-gi-cairo python3-pygccxml gccxml \
libssl-dev zlib1g-dev libbz2-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev ||
 	{ echo 'Dependency installation failed'; exit 1;}

#Add and enable a 1GB Swapfile
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

#Create a unique directory for the GNU Radio compile and make it the current directory
mkdir -p ~/src/GNURadio && cd ~/src/GNURadio

#download the Python Source code from the python.org repository
wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz ||
     { echo 'Unable to download the Python source code file'; exit 1; }
  
#Extract the Python source code files
tar -xvzf Python-3.9.1.tgz

#Make the directory containing the uncompressed Python source code the current directory
cd ~/src/GNURadio/Python-3.9.1

#Configure the Makefile for the Python compile
./configure --enable-optimizations --with-ensurepip=install

#Compile and install the Python libraries
make -j 3 && sudo make altinstall ||
  { echo 'Unable to install the Python Libraries'; exit 1; }

#Link the Python library files
sudo ldconfig

#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest Volk library source code from Github
git clone --recursive https://github.com/gnuradio/volk.git
  
#Create a directory for an indirect build of the Volk libraries and make it the current directory
mkdir -p ~/src/GNURadio/volk/build && cd ~/src/GNURadio/volk/build
	
#Configure the Makefile for the volk libraries compile
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ..

#Compile the Volk library files
make -j3

#Test the compiled Volk library files
make test

#Install the compiled Volk library files
sudo make install ||
  { echo 'Unable to install the volk libraries'; exit 1; }

#Link the volk library files
sudo ldconfig

#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest GNU Radio source code from Github
git clone https://github.com/gnuradio/gnuradio.git

#Make the directory containing the gnuradio source code the current directory
cd ~/src/GNURadio/gnuradio

#Checkout the maintained version of GNU Radio 3.9 from the cloned GNU Radio repository
git checkout maint-3.9
git submodule update --init --recursive

#Create a directory for an indirect build of GNU Radio and make it the current directory
mkdir -p ~/src/GNURadio/gnuradio/build && cd ~/src/GNURadio/gnuradio/build 

#Configure the Makefile for the GNU Radio compile
cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 ..

#Compile and install the gnuradio executable and support files
make -j3 && sudo make install ||
  { echo 'Unable to install gnuradio'; exit 1; }
  
#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest gr-grnet source block code from github
git clone https://github.com/ghostop14/gr-grnet.git

#Make the directory containing the gr-grnet source code the current directory
cd ~/src/GNURadio/gr-grnet

#Create a directory for an indirect build of gr-grnet and make it the current directory
mkdir -p ~/src/GNURadio/gr-grnet/build && cd ~/src/GNURadio/gr-grnet/build 
	
#Configure the Makefile for the gr-grnet source block compile
cmake ..

#Compile and install the gr-grnet source block
make && sudo make install ||
  { echo 'Unable to install gr-grnet'; exit 1; }
  
#Link the gr-grnet library files
sudo ldconfig

#Make the unique directory previously created for the GNU Radio compile the current directory 
cd ~/src/GNURadio

#Clone the latest digital_rf source code from Github
git clone --recursive https://github.com/MITHaystack/digital_rf.git
  
#Create a directory for an indirect build of the digital_rf code and make it the current directory
mkdir -p ~/src/GNURadio/digital_rf/build && cd ~/src/GNURadio/digital_rf/build
	
#Configure the Makefile for the digital_rf compile
cmake ..

#Compile the digital_rf files
make -j3

#Install the compiled digital_rf files
sudo make install ||
  { echo 'Unable to install digital_rf'; exit 1; }

#Link the digital_rf files
sudo ldconfig

#Make the GNU Radio Library and Python Path statements permanent
echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3.8/dist-packages" >> ~/.profile
echo "export LD_LIBRARY_PATH=/usr/local/lib" >> ~/.profile

#Install a Gnuradio Companion icon on the desktop
echo "[Desktop Entry]
Type=Application
Version=1.0
Encoding=UTF-8
Name=GNU Radio Companion
GenericName=Digital Signal Processing Software
Exec=/usr/local/bin/gnuradio-companion
Icon=/usr/local/share/icons/hicolor/32x32/apps/gnuradio-grc.png
Terminal=false
StartupNotify=false
Categories=Programming" >> ~/Desktop/gnuradio-companion.desktop ||
   { echo 'Unable to setup a gnuradio companion desktop icon'; exit 1;}
