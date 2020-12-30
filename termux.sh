#!/bin/bash
# Scripts for termux configuration
pkg upgrade -y
pkg install wget -y
pkg install git -y
pkg install micro -y
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/micro/bindings.json -O ~/.config/micro/bindings.json
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/micro/settings.json -O ~/.config/micro/settings.json
pkg install proot-distro -y
pkg install termux-api -y
git config --global user.email "sobanieca@gmail.com"
git config --global user.name "Adam Sobaniec"
git config --global credential.helper store
mkdir ~/.termux
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/termux.properties -O ~/.termux/termux.properties
termux-reload-settings
proot-distro install debian-buster
