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

Register the host once on the **client** with `ssh-new-host`. It asks for a
connection name, hostname, user, SSH port, identity file and the ports to
forward, shows what it will write, and then:

- appends a `Host` block to `~/.ssh/config` with keep-alives, connection sharing
  (`ControlMaster`) and one `LocalForward` per port
- creates `~/.ssh/cm` (mode 700) for the shared connection sockets
- appends to `~/.bashrc` an alias plus `fwd-NAME` / `unfwd-NAME` functions

```bash
ssh-new-host
source ~/.bashrc

my-dev                    # connect (same as: ssh my-dev)
fwd-my-dev 5173 6006      # forward more ports on the running connection
unfwd-my-dev 5173         # remove a forward
ssh -O exit my-dev        # close the shared connection and all its forwards
```

Example of the generated `~/.ssh/config` block:

```
# ssh-new-host: my-dev
Host my-dev
    HostName {vps-url}
    User {login-name}
    Port {port}
    IdentityFile ~/.ssh/id_rsa
    IdentitiesOnly yes

    TCPKeepAlive yes
    ServerAliveInterval 15
    ServerAliveCountMax 20
    LogLevel QUIET

    ControlMaster auto
    ControlPath ~/.ssh/cm/%C
    ControlPersist 10m

    LocalForward 8000 localhost:8000
```

> If you leave the identity file empty, the tool can generate a key and install
> it with `ssh-copy-id`, which asks for the password once. This only works while
> the server still allows password authentication. If you skip it, ssh asks for
> the password on each new connection.

> All sessions and forwards share one connection, so `fwd-NAME` needs no second
> login (no re-auth, no `maxsyslogins` conflict). They also go down together if
> it drops. If connecting hangs after a network drop, run `ssh -O exit NAME`.

> `ControlPersist 10m` keeps the connection and forwards up for 10 minutes after
> the last session closes. Forwards added with `fwd-NAME` last only as long as
> the connection. Put ports you always need into the config.

> To remove a host, delete its `# ssh-new-host: NAME` blocks from
> `~/.ssh/config` and `~/.bashrc`.

> Connection sharing does not work with Windows OpenSSH or PuTTY. There, connect
> with plain flags:
> `ssh -o ServerAliveInterval=15 -L 8000:localhost:8000 -l {login-name} -p {port} -i ~/.ssh/id_rsa {vps-url}`

> Ensure that sshd_config contains `AllowTcpForwarding yes`. If the key is
> rejected, check its permissions: `chmod 600 ~/.ssh/id_rsa`.

### Install on the client

To run it once without installing anything:

```bash
bash -c "$(wget -qO - https://raw.githubusercontent.com/sobanieca/env-setup/master/ssh-new-host)"
```

`update-configs` installs `ssh-new-host` to `~/tools`. On a client that is not
set up with this repo, install it with:

```bash
mkdir -p ~/tools
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/ssh-new-host -O ~/tools/ssh-new-host
chmod +x ~/tools/ssh-new-host
```

Add to the client's `~/.bashrc`:

```bash
export PATH="$HOME/tools:$PATH"
```

# Run

First run `apt-get update` then

```bash
bash -c "$(wget -O - https://raw.githubusercontent.com/sobanieca/env-setup/master/env-setup.sh)"
```

# Claude Remote Control on boot

`claude-rc-service` installs a systemd **user** service that keeps
`claude remote-control` running in a chosen directory, so the machine's sessions
are reachable from claude.ai/code and the Claude mobile app after every reboot.

It is installed to `~/tools` by `update-configs`. Run it once per machine:

```bash
claude-rc-service            # defaults to ~/code
claude-rc-service ~/work     # or any other directory
claude-rc-service -s same-dir ~/work   # spawn mode (default: worktree)
```

The script writes `~/.config/systemd/user/claude-rc.service`, enables it for
`default.target`, enables lingering for the user, and starts it.

```bash
systemctl --user status claude-rc          # is it running
journalctl --user -u claude-rc -f          # follow logs (session name, QR link)
systemctl --user disable --now claude-rc   # turn it off
```

# Claude usage window pinger

`claude-ping-cron` registers cron jobs that run `claude -p ping` at fixed hours,
so the 5-hour usage window always starts at a predictable time of day instead of
whenever the first prompt happens to be sent.

It is installed to `~/tools` by `update-configs`. Run it once per machine:

```bash
claude-ping-cron                       # default times, pings in ~/code
claude-ping-cron -d ~/work             # ping in another directory
claude-ping-cron 04:00 09:01 14:01     # custom times (UTC)
claude-ping-cron --show                # print the registered jobs
claude-ping-cron --ping                # ping now (same thing cron runs)
claude-ping-cron --remove              # drop the jobs
tail -f ~/.claude/ping-cron.log        # what each run printed
```

Re-running the tool replaces its managed block in `crontab -e`, so changing the
hours is just running it again with new ones. Other crontab entries are left
alone.

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
