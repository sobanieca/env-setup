# Commands to run in termux

```
pkg upgrade -y
pkg install wget -y
pkg install git -y
pkg install micro -y
pkg install proot-distro -y
pkg install termux-api -y
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
git config --global credential.helper store
wget https://raw.githubusercontent.com/sobanieca/env-setup/master/termux.properties -O ~/.termux/termux.properties
```

# Install debian

```
proot-distro install debian
```
