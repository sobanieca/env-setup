#!/bin/bash
# Run this script as a root user

# Add new user
adduser sobanieca

echo "run visudo and add following entry below root permissions: $USER ALL=(ALL) NOPASSWD:ALL"
echo "to change visudo editor type 'sudo update-alternatives --config editor'"

# Create ssh directory in ~ if not exists
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo "edit /etc/ssh/sshd_config file and specify #Port 22022"
echo "edit /etc/ssh/sshd_config file and disable root login #PermitRootLogin no"

echo "[windows] run puttygen, generate ssh key, save it, copy content to authorized_keys"
echo "[windows] if using putty, remember to specify user explicitly (not via prompt)"

echo "[unix] ssh-keygen -t rsa"
echo "[unix] ssh-copy-id sobanieca@dev.sobaniec.com"
echo "[unix] alias vps='ssh sobanieca@dev.sobaniec.com -p 22022' in .bashrc"
