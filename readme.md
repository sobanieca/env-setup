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
```
sudo nano /etc/security/limits.conf
* hard maxsyslogins 1
```

### Setup ssh client timeout

`sudo nano /etc/ssh/sshd_config`

search for `ClientAliveInterval`, if found set to 0

restart server or `sudo systemctl reload sshd.service`

### Setup hostname

```
sudo hostname {target hostname}
sudo nano /etc/hosts - replace old hostname references with the new one
```

> to change visudo editor type 'sudo update-alternatives --config editor'

## As a given user

### Create ssh directory in ~ if not exists

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

### Setup ssh port
```
edit /etc/ssh/sshd_config file and specify #Port different than 22
edit /etc/ssh/sshd_config file and disable root login #PermitRootLogin no
```

### Setup ssh key on Windows client
```
run puttygen, generate ssh key, save it, copy content to authorized_keys
if using putty, remember to specify user explicitly (not via prompt)
```

### Setup ssh key on Linux client

```bash
ssh-keygen -t rsa

ssh-copy-id -i ~/.ssh/id_rsa.pub -p {ssh_port} user@host

```

> `~/.ssh/id_rsa` is the private key, `~/.ssh/id_rsa.pub` is the public key

### Disable password authentication

After verifying that key-based login works, disable password authentication:

```
sudo nano /etc/ssh/sshd_config
```

Set the following:

```
PasswordAuthentication no
ChallengeResponseAuthentication no
```

Then reload:

```bash
sudo systemctl reload sshd.service
```

### Setup timezone information
`sudo dpkg-reconfigure tzdata`

# Connect

```bash
ssh -o TCPKeepAlive=yes -o ServerAliveCountMax=20 -o ServerAliveInterval=15 -q -L 3000:localhost:3000 -l {login-name} -p {port} -i ~/.ssh/id_rsa {vps-url}
```

> `-L 3000:localhost:3000` parameter is for port-forwarding to enable development. Ensure that sshd_config contains `AllowTcpForwarding yes`

# Run

First run `apt-get update` then

```bash
bash -c "$(wget -O - https://raw.githubusercontent.com/sobanieca/env-setup/master/env-setup.sh)"
```

# Termux setup

```bash
bash -c "$(wget -O - https://raw.githubusercontent.com/sobanieca/env-setup/master/termux.sh)"
```

Proot-distro has some bash init script which explicitly sets TERM variable under:
`./profile.d/termux-proot.sh:export TERM=xterm-256color`

This line needs to be removed as it's not compatible with `tmux`.

# WSL setup

On WSL one may want to enable systemd. To do this, create `/etc/wsl.conf` file with content:

```
[boot]
systemd=true
```

Also, mirrored network mode is beneficial. Add following to `C:\Users<YourUsername>.wslconfig`:

```
[wsl2]
networkingMode=mirrored
```

# Font setup (Nerd font)

For termux font should be installed as part of `termux.sh` script. For other terminals (like Windows Terminal) install 
Inconsolata Go font from `https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/InconsolataGo.zip`

Source: [Nerd fonts](https://www.nerdfonts.com/font-downloads)

# Final steps

### Setup fzf bash autocompletion

Add following to .bashrc file:

`source /usr/share/doc/fzf/examples/completion.bash`

If any issues occur run `apt-cache show fzf` for details on how to enable fuzzy autocompletion.

# Connection to remote ssh server

Use earlier steps to generate ssh key and upload it to remote machine.

In `.bashrc` file append following:

```bash
export REMOTE_SSH_CONFIG_PATH="/home/{users}/remote-config.json"
```

Inside json file provide following structure:

```
{
    "server": "{server}"
    "username": "{user}",
    "port": "{port}",
    "keyPath": "~/.ssh/id_rsa",
    "portForward": "3000,4000"
}
```

Run `remote` tool to connect to remote ssh server.

# Tips & Tricks

To view various notes about tools defined in this repository [go here](./notes.md)
