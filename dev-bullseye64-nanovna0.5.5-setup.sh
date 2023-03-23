#!/bin/sh
#install NanoVNA-Saver(0.5.5)
#N4XWE 3-23-2023
#Test Compiled on Raspberry PiOS-bullseye dtd 2023-02-22 64-bit

sudo apt update && sudo apt -y upgrade

sudo apt -y install git python3-scipy python3-numpy python3-pip python3-sipbuild

pip install PyQt6

mkdir -p ~/src/NANOVNA && cd ~/src/NANOVNA

git clone https://github.com/NanoVNA-Saver/nanovna-saver
 
cd nanovna-saver

sudo chmod +r ~/src/NANOVNA/nanovna-saver/nanovna-saver.py

python3 nanovna-saver.py

sudo cp /home/dan/src/NANOVNA/nanovna-saver/NanoVNASaver_48x48.png /usr/share/pixmaps/NanoVNASaver_48x48.png

echo "[Desktop Entry]
Name=Nano-Saver
GenericName=VNA Software Client
Comment=Runs NanoVNA Saver
Exec=$HOME/src/NANOVNA/nanovna-saver/nanovna-saver.py
Icon=/usr/share/pixmaps/NanoVNASaver_48x48.png
Terminal=false
Type=Application
Categories=Other;HamRadio;" > ~/Desktop/NanoVNA-Saver.desktop
