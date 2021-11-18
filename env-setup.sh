#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

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

# Install curl
echo "Installing curl..."
sudo apt-get install curl -y
echo "Curl installed."

# Install ripgrep
echo "Installing ripgrep..."
sudo apt-get install ripgrep -y
echo "Ripgrep installed"

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

# Install fzf
echo "Installing fzf..."
sudo apt-get install fzf -y
echo "fzf installed"

# Install Micro editor
echo "Installing/updating micro editor with plugins..."
if [ ! -f "$HOME/tools/micro" ]; then
	curl https://getmic.ro | bash
	./micro -plugin install editorconfig
	./micro -plugin install filemanager
	./micro -plugin install quoter
	./micro -plugin install manipulator
	./micro -plugin install fzf
	mv micro $HOME/tools/micro
else
	micro -plugin update editorconfig
	micro -plugin update filemanager
	micro -plugin update quoter
	micro -plugin update manipulator
	micro -plugin update fzf
fi
echo "Micro editor installed/updated"

wget $BASE_URL"update-configs.sh" -O $HOME/tools/update-configs.sh
chmod +x $HOME/tools/update-configs.sh
. $HOME/tools/update-configs.sh

# Install Tmux
echo "Installing tmux..."
sudo apt-get install tmux -y
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
echo "Tmux installed."
