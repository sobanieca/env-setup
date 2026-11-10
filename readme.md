# env-setup

Scripts for setting up a Debian VPS, so it's possible to code from any machine with an SSH client.
The client needs only bash and OpenSSH (Linux, macOS, WSL, Git Bash), nothing gets installed there.

## 1. Create a key (client)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sobanieca/env-setup/master/ssh-key-new)" ssh-key-new machine1
```

Creates `~/.secret/ssh-keys/machine1-key` and prints its public key: one line starting with `ssh-ed25519`, needed in
the next step. Keep the private key and back it up. To connect from another client, copy it to the same path there.

## 2. Set up the server (as root)

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/sobanieca/env-setup/master/server-setup)"
```

Asks for the user to create, the public key, the SSH port, extra ports to open (e.g. `8400,8404` for an app), the
hostname and the timezone. Then it installs basic tools (tmux, atop, htop, git without credentials, neovim, Node.js,
Claude Code) and the dotfiles, allows SSH only with the key on the new port, enables the firewall, and checks the
effective sshd configuration (`sshd -T`) and that a password login is refused.

Keep the root session open until you can log in as the new user.

## 3. Connect (client)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sobanieca/env-setup/master/ssh-new-host)"
source ~/.bashrc
machine1                  # connect
fwd-machine1 5173         # forward another port on the running connection
```

Asks for the name, hostname, user, port and ports to forward, and registers the host in `~/.ssh/config` and
`~/.bashrc`. The key defaults to `~/.secret/ssh-keys/NAME-key`. On the first connection, check that the fingerprint ssh
shows matches one printed at the end of `server-setup`.

When the server's IP changes, point the host to the new one:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/sobanieca/env-setup/master/ssh-host-ip)" ssh-host-ip machine1 203.0.113.7
```

## 4. Development server (as the new user)

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/sobanieca/env-setup/master/dev-setup)"
```

Sets your git name and email, installs the GitHub CLI and logs you in (also used as git credentials), installs Docker
with published ports bound to `127.0.0.1`, plus jsonr, sqlr, rfm and todoer, locks SSH to the IP you log in from, and
sets up `claude-rc-service` and `claude-ping-cron` in `~/code`. Log out and in again when it is done.

## Termux

```bash
bash -c "$(wget -O - https://raw.githubusercontent.com/sobanieca/env-setup/master/termux.sh)"
```

Sets up Termux on Android as a client: git, proot-distro, termux-api, colors and a Nerd font.

## More

Updating the dotfiles, SSH and server details, Claude services, WSL, fonts and tips: [notes.md](./notes.md)
