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

# Install lsd
echo "Installing lsd..."
sudo apt-get install lsd -y
echo "Lsd installed."

# Install Github CLI
echo "Installing Github CLI..."
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
echo "Github CLI installed."

# Install Docker
echo "Installing Docker..."
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER

echo "Configuring Docker logging..."
sudo tee /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
echo "Docker logging configured."
echo "Docker installed."

# Install Neovim
echo "Installing Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz

if ! grep -q '/opt/nvim-linux-x86_64/bin' "$HOME/.bashrc"; then
  echo '' >> "$HOME/.bashrc"
  echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> "$HOME/.bashrc"
  echo '' >> "$HOME/.bashrc"
fi
echo "Neovim installed."

# Install jsonr
echo "Installing jsonr..."
deno install -g --allow-write --allow-net --allow-read --allow-env=HOME,USERPROFILE -f -r -n jsonr jsr:@sobanieca/jsonr
echo "Jsonr installed."

# Install remote-file-manager
echo "Installing remote file manager..."
deno install -g --allow-write --allow-net --allow-read -f -r -n rfm jsr:@sobanieca/remote-file-manager
echo "Remote file manager installed."

# Update-configs script
wget $BASE_URL"update-configs" -O $HOME/tools/update-configs
chmod +x $HOME/tools/update-configs
. $HOME/tools/update-configs

echo "Environment configured. Now do the following:"
echo "* Open tmux and press ctrl+b,I to install tmux plugins"
echo "* Run `gh auth login` to authenticate in Github CLI"
echo "* Log out and log in so membership is re-evaluated to access Docker without sudo"
