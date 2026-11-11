# Notes

## Updating the dotfiles

`update-configs` (in `~/tools`) downloads the latest `bashrcx`, tmux, gitmux and Claude configs and the tools from this
repository, and the neovim configs when `nvim` is installed (see `neovim-setup`). In a local clone, `./sync` copies them
from the working tree instead.

## Server

### Re-running the setup scripts

`server-setup` and `dev-setup` can run again, e.g. to change the SSH port or the timezone. `server-setup` keeps the
previous user and port as defaults. `neovim-setup` can run again too, it updates Neovim to the latest release.

### Open or close ports

`server-setup --open-ports` only adds ports. Manage them later with ufw:

```bash
sudo ufw allow 8500/tcp
sudo ufw delete allow 8400/tcp
sudo ufw status verbose
```

### Check sshd

The effective configuration, after all files and `Match` blocks:

```bash
sudo sshd -T -C user=$USER,host=x,addr=203.0.113.1 | grep -Ei 'passwordauthentication|permitrootlogin|^port'
```

`server-setup` writes its settings to `/etc/ssh/sshd_config.d/00-env-setup.conf`. sshd takes the first value it reads
and the `00-` file is read first, so it wins over files like `50-cloud-init.conf`.

### Lock SSH to the login IP

`dev-setup` adds a block marked `# >>> env-setup: lock-ssh-ip >>>` to `~/.bashrc`. On each SSH login (not inside
tmux) it adds iptables rules that accept the SSH port only from the IP you connected from and drop SSH on the other IP
protocol. The rules are not persistent: after a reboot ufw's allow rule applies again. If your IP changes and you are
locked out, reboot the machine from the provider's panel and log in again. To turn it off, run
`dev-setup --no-lock-ip` or delete the block.

### Console login

The user has no password, so it can log in only with the SSH key. To log in from the provider's web console, set one:
`sudo passwd $USER`.

### Limit SSH to one login at a time

Optional:

```bash
echo '* hard maxsyslogins 1' | sudo tee /etc/security/limits.d/90-maxsyslogins.conf
```

The limit counts all logins on the machine, root included, so close any other session (e.g. the root session of
`server-setup`) first. Connections registered with `ssh-new-host` share one login, so `fwd-NAME` and additional
terminals keep working.

## Connect

`ssh-new-host` writes a `Host` block with keep-alives, connection sharing (`ControlMaster`) and one `LocalForward`
per port, and adds to `~/.bashrc` an alias plus `fwd-NAME` / `unfwd-NAME` functions:

```bash
my-dev                    # connect (same as: ssh my-dev)
fwd-my-dev 5173 6006      # forward more ports on the running connection
unfwd-my-dev 5173         # remove a forward
ssh -O exit my-dev        # close the shared connection and all its forwards
```

- All sessions and forwards share one connection, so `fwd-NAME` needs no second login. They also go down together if
  it drops. If connecting hangs after a network drop, run `ssh -O exit NAME`.
- `ControlPersist 10m` keeps the connection up for 10 minutes after the last session closes. Forwards added with
  `fwd-NAME` last only as long as the connection, put ports you always need into the config.
- `ssh-host-ip` without arguments lists the hosts with their HostName. `ssh-host-ip my-dev 203.0.113.7` changes the
  address and first closes a shared connection still open to the old one.
- To remove a host, delete its `# ssh-new-host: NAME` blocks from `~/.ssh/config` and `~/.bashrc`.
- To install the client tools to `~/tools` instead of running them with `bash -c`:

  ```bash
  mkdir -p ~/tools
  for t in ssh-key-new ssh-new-host ssh-host-ip; do
      curl -fsSL https://raw.githubusercontent.com/sobanieca/env-setup/master/$t -o ~/tools/$t
      chmod +x ~/tools/$t
  done
  ```

- Connection sharing does not work with Windows OpenSSH (outside WSL and Git Bash). There, connect with plain flags:
  `ssh -o ServerAliveInterval=15 -L 8000:localhost:8000 -p {port} -i ~/.secret/ssh-keys/{name}-key {user}@{host}`

## Claude Remote Control on boot

`claude-rc-service` (set up by `dev-setup`) installs a systemd user service that keeps `claude remote-control` running
in a directory, so the machine's sessions are reachable from claude.ai/code and the Claude mobile app after every
reboot.

```bash
claude-rc-service -s same-dir ~/code   # what dev-setup runs
claude-rc-service ~/work               # worktree spawn mode, needs a git repository
systemctl --user status claude-rc          # is it running
journalctl --user -u claude-rc -f          # follow logs (session name, QR link)
systemctl --user disable --now claude-rc   # turn it off
```

## Claude usage window pinger

`claude-ping-cron` (set up by `dev-setup`) registers cron jobs that run `claude -p ping` at fixed hours, so the 5-hour
usage window always starts at a predictable time of day.

```bash
claude-ping-cron                       # default times, pings in ~/code
claude-ping-cron 04:00 09:01 14:01     # custom times (UTC)
claude-ping-cron --show                # print the registered jobs
claude-ping-cron --remove              # drop the jobs
tail -f ~/.claude/ping-cron.log        # what each run printed
```

Re-running it replaces its block in the crontab, other entries are left alone.

## Termux

Proot-distro has a bash init script which sets the TERM variable:
`./profile.d/termux-proot.sh:export TERM=xterm-256color`. Remove this line, it is not compatible with `tmux`.

## Font (Nerd font)

`termux.sh` installs the font in Termux. For other terminals (like Windows Terminal) install InconsolataGo from
`https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/InconsolataGo.zip`
([Nerd fonts](https://www.nerdfonts.com/font-downloads)).

# Tips & Tricks

## Git

`git config credential.useHttpPath true`:
Setup repo specific credentials (useful, if one wants to keep `env-setup` repo, but works with other Github repos)

`git config user.email {email}`:
Setup user email locally for given repository

`git diff main...`:
Show changes only from feature branch relative to main

`gsquash -m "feat: some feature" 3`:
Squash last 3 commits into a single one with given single-line message

## Neovim

`ctrl+w,W`:
Focus on floating window

`ctrl+w,=`:
Realign windows after resize

`ctrl+w,{number},+ - > <`:
Resize split pane (width / height)

`g?`:
While on nvim-tree - show keyboard shortcuts

`:messages`:
View debug messages (for instance `print()` results from lua script)

`:checkhealth`:
Display health checks which may help troubleshooting plugins issues. For instance, if on `save` file, error occurs that `!` is required, it's indicator that
something is messed up.

`VISUAL mode + gc/gb`:
Comment out highlighted text (line/block comment)

`:!gshow 3 % feat/some-branch`:
Show current file content from 3 days ago on `feat/some-branch`

`neovim tree, select folder, press '.', type 'tcd'`:
Change working directory temporarily for current tab/window. Useful when doing things like `live-grep` in specific folder.

`visual mode, select area, ':', 's/.{4}$/;$/`:
Replace end of line (4 last characters) with ; symbol;

`ctrl+k, shift+k`:
Refresh autocomplete, show documentation

`gf`:
Go to file under cursor (if path is available)

`:windo set scrollbind`:
Lock scroll

## Chrome

Remote debug - to enable remote debug (Chrome MCP etc.) use following to start chrome:

`"C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --user-data-dir="C:\Users\{My USER}\chrome-debug"`

## Claude Code

Configure MCP servers in `~/.claude.json` file under root level:

```json
"mcpServers": {                                                                        
  "chrome-devtools": {                                                                 
    "type": "stdio",                                                                   
    "command": "npx",                                                                  
    "args": [                                                                          
      "chrome-devtools-mcp@latest",                                                    
      "--browserUrl",                                                                  
      "http://localhost:9222"                                                          
    ],                                                                                 
    "env": {}                                                                          
  },                                                                                   
  "figma-remote-mcp": {                                                                
    "type": "http",                                                                    
    "url": "https://mcp.figma.com/mcp"                                                 
  },                                                                                   
  "grafana": {                                                                         
    "command": "uvx",                                                                  
    "args": [                                                                          
      "mcp-grafana",                                                                   
      "--enabled-tools",                                                               
      "clickhouse,prometheus,datasource,cloudwatch,runpanelquery,dashboard"            
    ],                                                                                 
    "env": {                                                                           
      "GRAFANA_URL": "{url}",                                    
      "GRAFANA_SERVICE_ACCOUNT_TOKEN": "*****"
    }                                                                                
  }                                                                                    
}                                                                                      
```

## WSL

To enable systemd, create `/etc/wsl.conf` with:

```
[boot]
systemd=true
```

`.wslconfig` content (in `C:\Users\<YourUsername>\.wslconfig`), mirrored network mode is beneficial:

```
[wsl2]
memory=14GB
processors=8
networkingMode=mirrored
```

## Docker

`dev-setup` sets `"ip": "127.0.0.1"` in `/etc/docker/daemon.json`, so published ports bind to localhost by default.
Docker writes its own iptables rules and ufw does not filter published ports, so without it every `-p` port would be
open to the internet. To expose a port externally, set the address explicitly (e.g. `-p 0.0.0.0:8080:80`) and remember
that ufw does not block it.
