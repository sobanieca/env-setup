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
    mkdir $HOME/tools
    cat "bashrc.append" >> $HOME/.bashrc
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
    echo "set-option -g default-terminal \"screen-256color\"" >> $HOME/.tmux.conf
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
echo "Copy .vimrc to $HOME/.vimrc file"
echo "Vim installed."

echo "Installing Vim pathogen..."
if [ ! -d "$HOME/.vim/autoload" ] && [ ! -d "$HOME/.vim/bundle" ]; then
    mkdir -p $HOME/.vim/autoload $HOME/.vim/bundle && \
        curl -LSso $HOME/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi
echo "Vim pathogen installed."

echo "Installing/updating vim-airline..."
if [ ! -d "$HOME/.vim/bundle/vim-airline" ]; then
    cd $HOME/.vim/bundle &&
    git clone https://github.com/bling/vim-airline &&
    cd -
else
    cd $HOME/.vim/bundle/vim-airline &&
    git pull &&
    cd -
fi
echo "Vim-airline installed."

echo "Installing fugitive.vim..."
if [ ! -d "$HOME/.vim/bundle/vim-fugitive" ]; then
    cd $HOME/.vim/bundle &&
    git clone https://github.com/tpope/vim-fugitive &&
    cd -
else
    cd $HOME/.vim/bundle/vim-fugitive &&
    git pull &&
    cd -
fi
echo "Fugitive.vim installed."

echo "Installing The NERD tree..."
if [ ! -d "$HOME/.vim/bundle/nerdtree" ]; then
    cd $HOME/.vim/bundle &&
    git clone https://github.com/scrooloose/nerdtree &&
    cd -
else
    cd $HOME/.vim/bundle/nerdtree &&
    git pull &&
    cd -
fi
echo "The NERD tree installed."

echo "Installing Syntastic..."
if [ ! -d "$HOME/.vim/bundle/syntastic" ]; then
    cd $HOME/.vim/bundle &&
    git clone https://github.com/scrooloose/syntastic &&
    cd -
else
    cd $HOME/.vim/bundle/syntastic &&
    git pull &&
    cd -
fi
echo "Syntastic installed."

echo "Installing ctrlp.vim..."
if [ ! -d "$HOME/.vim/bundle/ctrlp.vim" ]; then      
    cd $HOME/.vim/bundle &&
    git clone https://github.com/ctrlpvim/ctrlp.vim &&
    cd -
else
    cd $HOME/.vim/bundle/ctrlp.vim &&
    git pull &&
    cd -
fi
echo "Ctrlp.vim installed"

echo "Installing dockerfiles syntax..."
if [ ! -d "$HOME/.vim/bundle/dockerfile" ]; then
    cd $HOME/.vim/bundle &&
    git clone https://github.com/ekalinin/Dockerfile.vim.git dockerfile &&
    cd -
else
    cd $HOME/.vim/bundle/dockerfile &&
    git pull &&
    cd -
fi
echo "Dockerfiles syntax installed."

echo "Installing Editorconfig-vim..."
if [ ! -d "$HOME/.vim/bundle/editorconfig-vim" ]; then
    cd $HOME/.vim/bundle &&
    git clone https://github.com/editorconfig/editorconfig-vim &&
    cd -
else
    cd $HOME/.vim/bundle/editorconfig-vim &&
    git pull &&
    cd -
fi
echo "Editorconfig-vim installed."

echo "Installing color theme..."
if [ ! -d "$HOME/.vim/colors" ]; then
    mkdir $HOME/.vim/colors
fi
cp aschema.vim $HOME/.vim/colors/aschema.vim
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
    git clone https://github.com/leafgarland/typescript-vim.git $HOME/.vim/bundle/typescript-vim
else
    cd $HOME/.vim/bundle/typescript-vim &&
    git pull &&
    cd -
fi
echo "Typescript syntax for vim installed."

# Install Typescript code completion for vim
echo "Installing Typescript code completion for vim..."
if [ ! -d "$HOME/.vim/bundle/tsuquyomi" ]; then
    git clone https://github.com/Quramy/tsuquyomi.git $HOME/.vim/bundle/tsuquyomi
else
    cd $HOME/.vim/bundle/tsuquyomi &&
    git pull &&
    cd -
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
