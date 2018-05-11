#!/bin/bash
# Run this script as a normal user with sudo command in preserve environment mode:
# sudo -u user -E ./env-config.sh
set -e

# Update system
echo "Updating system..."
apt-get update
apt-get dist-upgrade
echo "Finished update."

# Create tools directory and add it to path
echo "Creating tools directory and adding it to PATH variable..."
if [ ! -d "$HOME/tools" ]; then
    mkdir ~/tools
    cat "bashrc.append" >> ~/.bashrc
fi
echo "Tools directory created."

echo "Replacing/creating vimrc file..."
cp vimrc $HOME/.vimrc
echo "Vimrc file replaced."

# Install Tmux
echo "Installing tmux..."
apt-get install tmux -y
echo "Tmux installed."

echo "Creating tmux config file if not exists..."
if [ ! -f "$HOME/.tmux.conf" ]; then
    echo "set-option -g default-terminal \"screen-256color\"" >> ~/.tmux.conf
fi
echo "Tmux config file created"

# Install Node.js and npm
echo "Installing Node.js..."
curl -sL https://deb.nodesource.com/setup_8.x | bash -
apt-get install -y nodejs
echo "Node.js installed."

# Update npm to latest version
echo "Updating npm..."
npm install npm@latest -g
echo "npm updated."

# Install curl
echo "Installing curl..."
apt-get install curl -y
echo "Curl installed."

# Install dos2unix
echo "Installing dos2unix..."
apt-get install dos2unix -y
echo "Dos2unix installed."

# Install GIT
echo "Installing Git..."
apt-get install git -y
echo "Git installed."

echo "Setting Git credential store..."
git config --global credential.helper store
echo "Configured credential store."

# Install VIM
echo "Installing Vim..."
apt-get install vim -y
echo "Copy .vimrc to ~/.vimrc file"
echo "Vim installed."

echo "Installing Vim pathogen..."
if [ ! -d "$HOME/.vim/autoload" ] && [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
        curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi
echo "Vim pathogen installed."

echo "Installing/updating vim-airline..."
if [ ! -d "$HOME/.vim/bundle/vim-airline" ]; then
    cd ~/.vim/bundle
    git clone https://github.com/bling/vim-airline
else
    cd ~/.vim/bundle/vim-airline
    git pull
fi
echo "Vim-airline installed."

echo "Installing fugitive.vim..."
if [ ! -d "$HOME/.vim/bundle/vim-fugitive" ]; then
    cd ~/.vim/bundle
    git clone https://github.com/tpope/vim-fugitive
else
    cd ~/.vim/bundle/vim-fugitive
    git pull
fi
echo "Fugitive.vim installed."

echo "Installing The NERD tree..."
if [ ! -d "$HOME/.vim/bundle/nerdtree" ]; then
    cd ~/.vim/bundle
    git clone https://github.com/scrooloose/nerdtree
else
    cd ~/.vim/bundle/nerdtree
    git pull
fi
echo "The NERD tree installed."

echo "Installing Syntastic..."
if [ ! -d "$HOME/.vim/bundle/syntastic" ]; then
    cd ~/.vim/bundle
    git clone https://github.com/scrooloose/syntastic
else
    cd ~/.vim/bundle/syntastic
    git pull
fi
echo "Syntastic installed."

echo "Installing ctrlp.vim..."
if [ ! -d "$HOME/.vim/bundle/ctrlp.vim" ]; then      
    cd ~/.vim/bundle
    git clone https://github.com/ctrlpvim/ctrlp.vim
else
    cd ~/.vim/bundle/ctrlp.vim
    git pull
fi
echo "Ctrlp.vim installed"

echo "Installing dockerfiles syntax..."
if [ ! -d "$HOME/.vim/bundle/dockerfile" ]; then
    cd ~/.vim/bundle
    git clone https://github.com/ekalinin/Dockerfile.vim.git dockerfile
else
    cd ~/.vim/bundle/dockerfile
    git pull
fi
echo "Dockerfiles syntax installed."

echo "Installing Editorconfig-vim..."
if [ ! -d "$HOME/.vim/bundle/editorconfig-vim" ]; then
    cd ~/.vim/bundle
    git clone https://github.com/editorconfig/editorconfig-vim
else
    cd ~/.vim/bundle/editorconfig-vim
    git pull
fi
echo "Editorconfig-vim installed."

echo "Installing color theme..."
if [ ! -d "$HOME/.vim/colors" ]; then
    mkdir ~/.vim/colors
fi
cp aschema.vim ~/.vim/colors/aschema.vim
echo "Color theme for Vim installed."

# Install Typescript
echo "Installing Typescript..."
npm install typescript -g
echo "Typescript installed."

# Install TSLint
echo "Installing TSLint..."
npm install -g tslint
echo "TSLint installed"

# Install Typescript syntax for vim
echo "Installing Typescript syntax for vim..."
if [ ! -d "$HOME/.vim/bundle/typescript-vim" ]; then
    git clone https://github.com/leafgarland/typescript-vim.git ~/.vim/bundle/typescript-vim
else
    cd ~/.vim/bundle/typescript-vim
    git pull
fi
echo "Typescript syntax for vim installed."

# Install Typescript code completion for vim
echo "Installing Typescript code completion for vim..."
if [ ! -d "$HOME/.vim/bundle/tsuquyomi" ]; then
    git clone https://github.com/Quramy/tsuquyomi.git ~/.vim/bundle/tsuquyomi
else
    cd ~/.vim/bundle/tsuquyomi
    git pull
fi
echo "Typescript code completion installed."

# Install Lynx
echo "Installing Lynx..."
apt-get install lynx -y
echo "Lynx installed."

# Install atop
echo "Installing atop..."
apt-get install atop -y
echo "atop installed"

# Update global npm packages
echo "Updating global npm packages..."
npm update -g
echo "Finished updating global npm packages"
