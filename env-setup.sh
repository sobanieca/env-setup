#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

# Update system
echo "Registering additional package repositories"
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
echo "Finished registration"

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
git config --global pull.ff only
echo "Git installed."

# Install atop
echo "Installing atop..."
sudo apt-get install atop -y
echo "atop installed"

# Install fzf
echo "Installing fzf..."
sudo apt-get install fzf -y
echo "fzf installed"

# Install vim
echo "Installing vim..."
sudo apt-get install vim -y
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Vim installed"

# Install Node.js
echo "Installing nvm and node.js..."
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts
nvm use --lts
echo "nvm and node.js installed"

# Install Deno
echo "Installing Deno..."
sudo apt-get install unzip -y
curl -fsSL https://deno.land/install.sh | sh
echo "Deno installed"

# Update-configs script
wget $BASE_URL"update-configs" -O $HOME/tools/update-configs
chmod +x $HOME/tools/update-configs
. $HOME/tools/update-configs

# Install Tmux
echo "Installing tmux..."
sudo apt-get install tmux -y
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
echo "Tmux installed."

# Install tshark
echo "Installing tshark..."
sudo apt-get install tshark -y
echo "Tshark installed."

