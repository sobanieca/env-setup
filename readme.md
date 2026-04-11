# env-setup

Scripts for setting up development environment on Debian machine, so it's possible to code from any machine with SSH client

# prerequisites

One needs to configure user account and ssh to proceed:

## As a root user

### Add new user
`adduser {user}`

### Configure user permissions
`run visudo and add following entry below root permissions: $USER ALL=(ALL) NOPASSWD:ALL`

> to change visudo editor type 'sudo update-alternatives --config editor'

### Limit parallel ssh sessions to 1
```
sudo nano /etc/security/limits.conf
* hard maxsyslogins 1
```

### Setup hostname

```
sudo hostname {target hostname}
sudo nano /etc/hosts - replace old hostname references with the new one
```

### Configure SSHD 

Edit `/etc/ssh/sshd_config` and apply all of the following in a single edit:

```
sudo nano /etc/ssh/sshd_config
```

- `Port` — set to a non-default value (not `22`)
- `PermitRootLogin no` — disable root SSH login
- `ClientAliveInterval 0` — support long-lived SSH sessions
- `AllowTcpForwarding yes` — enable port forwarding for development

Then reload sshd (first restart):

```bash
sudo systemctl reload sshd.service
```

> You may need to check `/etc/ssh/sshd_config.d` for files that potentially override the main config. If so, update it there as well.

> Keep this root session open until you've confirmed you can reconnect as the new user on the new port.

## As a given user

Disconnect from the root session and reconnect as the newly created user on the new SSH port:

```bash
ssh -p {ssh_port} {user}@{host}
```

### Create ssh directory in ~ if not exists

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
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

Open a fresh SSH session using the key to confirm key-based login works before
proceeding. Keep your current session open as a fallback in case something is
wrong with the key setup.

Once verified, edit sshd config one more time:

```
sudo nano /etc/ssh/sshd_config
```

Set the following:

```
PasswordAuthentication no
ChallengeResponseAuthentication no
```

Then reload sshd (second restart):

```bash
sudo systemctl reload sshd.service
```

> Again check `/etc/ssh/sshd_config.d` for override files
> and update them there if needed.

### Setup firewall

Allow only SSH traffic using `ufw`:

```bash
sudo apt install ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow {ssh_port}/tcp
sudo ufw enable
sudo ufw status verbose
```

> Always allow SSH before enabling the firewall to avoid locking yourself out.

#### Lock SSH to current IP on login

To automatically restrict SSH access to only the currently connected IP, add the following to `.bashrc`.
Replace `{ssh_port}` with your SSH port

```bash
# Lock SSH to current IP (iptables - non-persistent, works alongside ufw)
MY_IP=$(echo "$SSH_CONNECTION" | awk '{print $1}')
if [ -n "$MY_IP" ]; then
    if ! sudo iptables -C INPUT -p tcp --dport {ssh_port} -s "$MY_IP" -j ACCEPT 2>/dev/null; then
        sudo iptables -S INPUT | grep -E "\-\-dport {ssh_port}" | sed 's/^-A/-D/' | while read -r rule; do
            sudo iptables $rule
        done
        sudo iptables -I INPUT 1 -p tcp --dport {ssh_port} -s "$MY_IP" -j ACCEPT
        sudo iptables -I INPUT 2 -p tcp --dport {ssh_port} -j DROP
    fi
fi
```

- On reboot, these rules disappear and UFW's generic `allow {ssh_port}/tcp` takes effect again

### Setup timezone information
`sudo dpkg-reconfigure tzdata`

# Connect

```bash
ssh -o TCPKeepAlive=yes -o ServerAliveCountMax=20 -o ServerAliveInterval=15 -q -L 8000:localhost:8000 -l {login-name} -p {port} -i ~/.ssh/id_rsa {vps-url}
```

> `-L 8000:localhost:8000` parameter is for port-forwarding to enable development. Add as many ports as you need for development.
> Ensure that sshd_config contains `AllowTcpForwarding yes`

> If command doesn't work, ensure that private key has proper permissions. If not, run `chmod 600 ~/.ssh/id_rsa` (or other path if needed)

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

# Tips & Tricks

To view various notes about tools defined in this repository [go here](./notes.md)
