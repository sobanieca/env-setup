#!/bin/bash
set -e

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

echo "Updating .bashrcx file..."
wget $BASE_URL"bashrcx" -O $HOME/.bashrcx
echo ".bashrcx file updated."

echo "Updating .curlrc file..."
wget $BASE_URL"curlrc" -O $HOME/.curlc
echo ".curlrc file updated."

echo "Replacing/creating tmux.conf file..."
wget $BASE_URL"tmux.conf" -O $HOME/.tmux.conf
echo "Tmux.conf file replaced."

echo "Updatint .vimrc..."
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/vimrc -O $HOME/.vimrc
echo ".vimrc updated."
