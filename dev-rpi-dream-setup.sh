#!/bin/bash
#install Dream(2.2) with FAAD2(2.7) and FAAC(1.28)
#N4XWE 12-9-2020
#Visit http://www.iquadlabs.com

set -e

QMAKE_EXEC=qmake-qt4
MAKE_ARGS=-j3


#Update the apt cache and upgrade the system packages to their latest versions
sudo apt update && sudo apt upgrade -y

#Install the required dependencies
sudo apt install -y libhamlib2 libqwt6abi1 g++ unzip make qt4-dev-tools libsysfs-dev automake \
libtool libtool-bin libqtwebkit-dev libqt5webkit5-dev libpulse-dev libhamlib-dev \
libfftw3-dev libqwt-dev libsndfile1-dev zlib1g-dev libgl1-mesa-dev libqt4-opengl-dev

#Create a unique directory for the DREAM compile and make it the current directory
mkdir -p ~/src/DREAM && cd ~/src/DREAM

#Build and install FAAD2 library
wget https://sourceforge.net/projects/faac/files/faad2-src/faad2-2.7/faad2-2.7.tar.gz
tar zxf faad2-2.7.tar.gz
cd faad2-2.7
. bootstrap
./configure --enable-shared --without-xmms --with-drm --without-mpeg4ip
make $MAKE_ARGS
sudo cp include/faad.h include/neaacdec.h /usr/include
sudo cp libfaad/.libs/libfaad.so.2.0.0 /usr/local/lib/libfaad2_drm.so.2.0.0
sudo ln -s /usr/local/lib/libfaad2_drm.so.2.0.0 /usr/local/lib/libfaad2_drm.so.2
sudo ln -s /usr/local/lib/libfaad2_drm.so.2.0.0 /usr/local/lib/libfaad2_drm.so
cd ..

#Build and install FAAC library
wget https://sourceforge.net/projects/faac/files/faac-src/faac-1.28/faac-1.28.tar.gz
tar zxf faac-1.28.tar.gz
cd faac-1.28
. bootstrap
./configure --with-pic --enable-shared --without-mp4v2 --enable-drm
make $MAKE_ARGS
sudo cp include/faaccfg.h  include/faac.h /usr/include
sudo cp libfaac/.libs/libfaac.so.0.0.0 /usr/local/lib/libfaac_drm.so.0.0.0
sudo ln -s /usr/local/lib/libfaac_drm.so.0.0.0 /usr/local/lib/libfaac_drm.so.0
sudo ln -s /usr/local/lib/libfaac_drm.so.0.0.0 /usr/local/lib/libfaac_drm.so
cd ..

#Build and install Dream
wget http://downloads.sourceforge.net/drm/dream_2.2.orig.tar.gz
tar zxf dream_2.2.orig.tar.gz
cd dream_2.2
sed -i -- 's#$$OUT_PWD#/usr#g' dream.pro
sed -i -- 's#faad_drm#faad2_drm#g' dream.pro
$QMAKE_EXEC
make $MAKE_ARGS
sudo cp dream /usr/local/bin/dream
sudo cp src/GUI-QT/res/MainIcon.svg /usr/share/icons/dream.svg
printf "[Desktop Entry]\nVersion=1.0\nType=Application\nName=Dream\nComment=Software Digital Radio Mondiale Receiver\nTryExec=/usr/local/bin/dream\nExec=/usr/local/bin/dream\nIcon=dream.svg\nCategories=Audio;AudioVideo;Science;Electronics\n" | tee dream.desktop
cp dream.desktop ~/.local/share/applications/dream.desktop
cd ..
sudo ldconf

#Cleanup

rm dream_2.2.orig.tar.gz
rm faac-1.28.tar.gz
rm faad2-2.7.tar.gz
rm -rf ./dream
rm -rf ./faac-1.28
rm -rf ./faad2-2.7

