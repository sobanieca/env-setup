# Tips & Tricks

## Git configuration

`git config credential.useHttpPath true`:
Setup repo specific credentials (useful, if one wants to keep `env-setup` repo, but works with other Github repos)

`git config user.email {email}`:
Setup user email locally for given repository

## Neovim

`ctrl+w,w`:
Focus on floating window

`ctrl+w,=`:
Realign windows after resize

`ctrl+w,{number},+ - > <`:
Resize split pane (width / height)

`g?`:
While on nvim-tree - show keyboard shortcuts

`:messages`:
View debug messages (for instance `print()` results from lua script)

`VISUAL mode + gc/gb`:
Comment out highlighted text (line/block comment)

## Tmux

`ctrl+space`, `c` type `swap-panes -D`:
Swap open panes

## WSL

```
/etc>cat wsl.conf
[user]
default={user}

[boot]
systemd=true
```
Enable systemd
