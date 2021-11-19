# env-setup

Scripts for setting up development environment on Debian machine, so it's possible to code from any machine with SSH client

# prerequisites

One needs to configure user account and ssh to proceed:

## As a root user

### Add new user
`adduser {user}`

### Configure user permissions
`run visudo and add following entry below root permissions: $USER ALL=(ALL) NOPASSWD:ALL`

### Limit parallel ssh sessions to 1
`sudo nano /etc/security/limits.conf`
`* hard maxsyslogins 1`

### Setup ssh client timeout

`sudo nano /etc/ssh/sshd_config`

search for `ClientAliveInterval ...`, if found set to 0

restart server or `sudo systemctl reload sshd.service`

### Setup hostname

`sudo hostname {target hostname}`

`sudo nano /etc/hosts` - replace old hostname references with the new one

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

### Setup timezone information
`sudo dpkg-reconfigure tzdata`

# Connect

`ssh -o TCPKeepAlive=yes -o ServerAliveCountMax=20 -o ServerAliveInterval=15 -L 3000:localhost:3000 -l {login-name} -p {port} -i {path-to-ssh-key} {vps-url}`

`-L 3000:localhost:3000` parameter is for port-forwarding to enable development. Ensure that sshd_config contains `AllowTcpForwarding yes`

# Run

First run `apt-get update` then
`bash -c "$(wget -O - https://raw.githubusercontent.com/sobanieca/env-setup/master/env-setup.sh)"`

# Termux setup

`bash -c "$(wget -O - https://raw.githubusercontent.com/sobanieca/env-setup/master/termux.sh)"`
