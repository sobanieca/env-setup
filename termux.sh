#!/bin/bash
# Scripts for termux configuration
pkg upgrade -y
pkg install wget -y
pkg install git -y
pkg install proot-distro -y
pkg install termux-api -y
git config --global user.email "sobanieca@gmail.com"
git config --global user.name "Adam Sobaniec"
git config --global credential.helper store
mkdir ~/.termux
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/termux.properties -O ~/.termux/termux.properties
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/colors.properties -O ~/.termux/colors.properties
mkdir nerdfont
cd nerdfont
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/InconsolataGo.zip -O font.zip
unzip font.zip
mv InconsolataGoNerdFontMono-Regular.ttf ~/.termux/font.ttf
cd ..
rm -rf nerdfont
termux-reload-settings
git clone https://github.com/sobanieca/env-setup.git
proot-distro install debian
