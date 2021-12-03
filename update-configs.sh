#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

echo "Updating .bashrcx file..."
wget $BASE_URL"bashrcx" -O $HOME/.bashrcx
echo ".bashrcx file updated."

echo "Replacing/creating tmux.conf file..."
wget $BASE_URL"tmux.conf" -O $HOME/.tmux.conf
echo "Tmux.conf file replaced."

echo "Updating micro editor configs..."
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/micro/bindings.json -O $HOME/.config/micro/bindings.json
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/micro/settings.json -O $HOME/.config/micro/settings.json
echo "Micro editor configs updated"

echo "Updatint .vimrc..."
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/vimrc -O $HOME/.vimrc
echo ".vimrc updated."
