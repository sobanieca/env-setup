#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

wget $BASE_URL"aschema.vim"
wget $BASE_URL"bashrcx"
wget $BASE_URL"env-config.sh"
wget $BASE_URL"tmux.conf"
wget $BASE_URL"vimrc"

chmod +x env-config.sh

. env-config.sh

