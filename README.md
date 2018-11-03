# env-setup
Scripts for setting up development environment on Debian machine, so it's possible to code from any machine with SSH client

# prerequisites

One needs to configure user account and ssh to proceed:

## As a root user

### Add new user
`adduser {user}`

### Configure user permissions
`run visudo and add following entry below root permissions: $USER ALL=(ALL) NOPASSWD:ALL`

>to change visudo editor type 'sudo update-alternatives --config editor'

## As a given user

### Create ssh directory in ~ if not exists
`mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys`

### Setup ssh port
`edit /etc/ssh/sshd_config file and specify #Port different than 22`
`edit /etc/ssh/sshd_config file and disable root login #PermitRootLogin no`

### Setup ssh key on Windows client
`run puttygen, generate ssh key, save it, copy content to authorized_keys`
`if using putty, remember to specify user explicitly (not via prompt)`

### Setup ssh key on Linux client
`ssh-keygen -t rsa`
`ssh-copy-id user@host`
`alias vps='ssh user@host -p {ssh_port}' in .bashrc`

# Run

sudo -E wget https://raw.githubusercontent.com/sobanieca/env-setup/master/install.sh && chmod +x install.sh && ./install.sh

