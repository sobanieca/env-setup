#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

mkdir temp-env-setup
cd temp-env-setup

wget $BASE_URL"aschema.vim"
wget $BASE_URL"bashrcx"
wget $BASE_URL"env-config.sh"
wget $BASE_URL"tmux.conf"
wget $BASE_URL"vimrc"

sudo -E wget -O - $BASE_URL/env-config.sh | bash

cd ..
rm -rf temp-env-setup

