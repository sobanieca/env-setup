# env-setup
Scripts for setting up development environment on Debian machine, so it's possible to code from any machine with SSH client

#!/bin/bash
# Run this script as a root user

# Add new user
adduser {user}

echo "run visudo and add following entry below root permissions: $USER ALL=(ALL) NOPASSWD:ALL"
echo "to change visudo editor type 'sudo update-alternatives --config editor'"

