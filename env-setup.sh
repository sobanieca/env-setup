#!/bin/bash
set -e

is_termux=false
if [[ $PREFIX == *"termux"* ]]; then
    is_termux=true
fi

# Update system
echo "Updating system..."
if [ "$is_termux" = true ]; then
    apt-get update
    apt-get dist-upgrade
else
    sudo apt-get update
    sudo apt-get dist-upgrade
fi
echo "Finished update."

# Create tools directory and add it to path
if [ ! -d "$HOME/tools" ]; then
    echo "Creating tools directory and adding it to PATH variable..."
    mkdir $HOME/tools
    echo "Tools directory created."
fi

if ! grep --quiet  bashrcx $HOME/.bashrc; then
    echo "Creating bashrc extensions file..."
    cp bashrcx $HOME/.bashrcx
    echo ". ~/.bashrcx" >> $HOME/.bashrc
    echo "Bashrc extensions file copied."
fi

echo "Replacing/creating vimrc file..."
cp vimrc $HOME/.vimrc
echo "Vimrc file replaced."

# Install Tmux
echo "Installing tmux..."
if [ "$is_termux" = true ]; then
    apt-get install tmux -y
else
    sudo apt-get install tmux -y
fi
echo "Tmux installed."

echo "Replacing/creating tmux.conf file..."
cp tmux.conf $HOME/.tmux.conf
echo "Tmux.conf file replaced."

# Install Node Version Manager
echo "Installing Node.js..."
if [ "$is_termux" = true ]; then
    pkg install nodejs -y
else
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
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
if [ "$is_termux" = true ]; then
    apt-get install git -y
else
    sudo apt-get install git -y
fi
echo "Git installed."

echo "Setting Git credential store..."
git config --global credential.helper store
echo "Configured credential store."

# Install VIM
echo "Installing Vim..."
if [ "$is_termux" = true ]; then
    apt-get install vim -y
else
    sudo apt-get install vim -y
fi
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

# Install atop
echo "Installing atop..."
if [ "$is_termux" = true ]; then
    apt-get install atop -y
else
    sudo apt-get install atop -y
fi
echo "atop installed"

# Update global npm packages
echo "Updating global npm packages..."
npm update -g
echo "Finished updating global npm packages"
