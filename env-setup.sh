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
    echo "Creating bashrc extensions file..."
    wget $BASE_URL"bashrcx" -O $HOME/.bashrcx
    echo ". ~/.bashrcx" >> $HOME/.bashrc
    echo "Bashrc extensions file copied."
fi

# Install Tmux
echo "Installing tmux..."
if [ "$is_termux" = true ]; then
    apt-get install tmux -y
else
    sudo apt-get install tmux -y
fi
echo "Tmux installed."

echo "Replacing/creating tmux.conf file..."
wget $BASE_URL"tmux.conf" -O $HOME/.tmux.conf
echo "Tmux.conf file replaced."

# Install Node Version Manager
echo "Installing Node.js..."
if [ "$is_termux" = true ]; then
    pkg install nodejs -y
else
    wget -qO- wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm install node
    nvm use node
fi
echo "Node.js installed."

# Update npm to latest version
echo "Updating npm..."
npm install npm@latest -g
echo "npm updated."

# Install curl
echo "Installing curl..."
if [ "$is_termux" = true ]; then
    apt-get install curl -y
else
    sudo apt-get install curl -y
fi
echo "Curl installed."

# Install dos2unix
echo "Installing dos2unix..."
if [ "$is_termux" = true ]; then
    apt-get install dos2unix -y
else
    sudo apt-get install dos2unix -y
fi
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
