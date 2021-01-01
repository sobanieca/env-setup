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
    echo "Registering .bashrcx file..."
    echo ". ~/.bashrcx" >> $HOME/.bashrc
    echo "Bashrcx file registered."
fi

# Install Tmux
echo "Installing tmux..."
sudo apt-get install tmux -y
echo "Tmux installed."

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
echo "Installing/updating micro editor with plugins..."
if [ ! -d "$HOME/tools/micro" ]; then
	curl https://getmic.ro | bash
	./micro -plugin install editorconfig
	./micro -plugin install filemanager
	./micro -plugin install quoter
	./micro -plugin install manipulator
	mv micro $HOME/tools/micro
else
	micro -plugin update editorconfig
	micro -plugin update filemanager
	micro -plugin update quoter
	micro -plugin update manipulator
fi
echo "Micro editor installed/updated"

wget $BASE_URL"update-configs.sh" -O $HOME/tools/update-configs.sh
chmod +x $HOME/tools/update-configs.sh
bash $HOME/tools/update-configs.sh
