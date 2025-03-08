#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"
ARCH=$(dpkg --print-architecture)

# Update system
echo "Registering additional package repositories..."
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
echo "Finished registration."

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
echo "Ripgrep installed."

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
git config --global pull.ff only
git config --global stash.showIncludeUntracked true
echo "Git installed."

# Install atop
echo "Installing atop..."
sudo apt-get install atop -y
echo "Atop installed."

# Install fzf
echo "Installing fzf..."
sudo apt-get install fzf -y
echo "Fzf installed."

# Install jq
echo "Installing jq..."
sudo apt-get install jq -y
echo "Jq installed."

# Install C++ build tools
echo "Installing C++ build tools..."
sudo apt-get install g++ -y
echo "C++ build tools installed."

# Install Node.js
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt-get install -y nodejs
echo "Node.js installed."

# Install Deno
echo "Installing Deno..."
sudo apt-get install unzip -y
curl -fsSL https://deno.land/install.sh | sh || true
echo "Deno installed."

# Install Tmux
echo "Installing tmux..."
sudo apt-get install tmux -y
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi
echo "Tmux installed."

# Install Gitmux
echo "Installing gitmux..."
mkdir temp
cd temp
if [ "$ARCH" == "arm64" ];
then
  wget https://github.com/arl/gitmux/releases/download/v0.10.3/gitmux_v0.10.3_linux_arm64.tar.gz
  tar -xf gitmux_v0.10.3_linux_arm64.tar.gz
else
  wget https://github.com/arl/gitmux/releases/download/v0.10.3/gitmux_v0.10.3_linux_amd64.tar.gz
  tar -xf gitmux_v0.10.3_linux_amd64.tar.gz
fi
sudo mv gitmux /usr/local/bin
cd ..
rm -rf temp
echo "Gitmux installed."

# Install tshark
echo "Installing tshark..."
sudo apt-get install tshark -y
echo "Tshark installed."

# Install lsd
echo "Installing lsd..."
sudo apt-get install lsd -y
echo "Lsd installed."

# Install Claude Code
echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code
echo "Claude Code installed."

# Update-configs script
wget $BASE_URL"update-configs" -O $HOME/tools/update-configs
chmod +x $HOME/tools/update-configs
. $HOME/tools/update-configs

