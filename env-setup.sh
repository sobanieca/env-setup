#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

apt-get install sudo -y

# Update system
echo "Updating system..."
sudo apt-get update
sudo apt-get dist-upgrade
echo "Finished update."

# Create tools directory and add it to path
if [ ! -d "$HOME/tools" ]; then
    echo "Creating tools directory and adding it to PATH variable..."
    mkdir $HOME/tools
    echo "Tools directory created."
fi

if ! grep --quiet  bashrcx $HOME/.bashrc; then
    echo "Creating bashrc extensions file..."
    wget $BASE_URL"bashrcx" -O $HOME/.bashrcx
    echo ". ~/.bashrcx" >> $HOME/.bashrc
    echo "Bashrc extensions file copied."
fi

# Install Tmux
echo "Installing tmux..."
sudo apt-get install tmux -y
echo "Tmux installed."

echo "Replacing/creating tmux.conf file..."
wget $BASE_URL"tmux.conf" -O $HOME/.tmux.conf
echo "Tmux.conf file replaced."

# Install Node Version Manager
echo "Installing Node.js..."
curl -sL https://deb.nodesource.com/setup_15.x | bash -
apt-get install -y nodejs
echo "Node.js installed."

# Update npm to latest version
echo "Updating npm..."
npm install npm@latest -g
echo "npm updated."

# Install curl
echo "Installing curl..."
sudo apt-get install curl -y
echo "Curl installed."

# Install dos2unix
echo "Installing dos2unix..."
sudo apt-get install dos2unix -y
echo "Dos2unix installed."

# Install GIT
echo "Installing Git..."
sudo apt-get install git -y
git config --global user.email "sobanieca@gmail.com"
git config --global user.name "Adam Sobaniec"
git config --global credential.helper store
echo "Git installed."

# Install atop
echo "Installing atop..."
sudo apt-get install atop -y
echo "atop installed"

# Install Micro editor
echo "Installing Micro editor with plugins..."
curl https://getmic.ro | bash
./micro -plugin install editorconfig
./micro -plugin install filemanager
./micro -plugin install quoter
./micro -plugin install manipulator
mv micro $HOME/tools/micro
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/micro/bindings.json -O $HOME/.config/micro/bindings.json
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/micro/settings.json -O $HOME/.config/micro/settings.json
echo "Micro editor installed."
