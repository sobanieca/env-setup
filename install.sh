#!/bin/bash

BASE_URL="https://raw.githubusercontent.com/sobanieca/env-setup/master/"

mkdir env-setup
cd env-setup

wget $BASE_URL"bashrcx"
wget $BASE_URL"tmux.conf"
wget $BASE_URL"env-setup.sh"

cd ..

echo "cd env-setup and run ./env-setup.sh"
