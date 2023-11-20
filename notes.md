# Tips & Tricks

## Git configuration

`git config credential.useHttpPath true`:
Setup repo specific credentials (useful, if one wants to keep `env-setup` repo, but works with other Github repos)

`git config user.email {email}`:
Setup user email locally for given repository

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

`:!gshow 3 %`:
Show current file content from 3 days ago

`:!gshow 3 % feat/some-branch`:
Show current file content from 3 days ago on `feat/some-branch`

`:read !gshow 3 %`:
Insert output of gshow into current buffer

`neovim tree, select folder, press '.', type 'tcd'`:
Change working directory temporarily for current tab/window. Useful when doing things like `live-grep` in specific folder.

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
