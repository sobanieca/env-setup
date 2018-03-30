#!/bin/bash
# Run this script as a root user

# Add new user
adduser sobanieca

echo "run visudo and add following entry below root permissions: $USER ALL=(ALL) NOPASSWD:ALL"
echo "to change visudo editor type 'sudo update-alternatives --config editor'"

