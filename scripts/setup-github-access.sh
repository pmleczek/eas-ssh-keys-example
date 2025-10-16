#!/bin/bash

GIT_USER_NAME="<Your name>"
GIT_USER_EMAIL="<Your email>"

# Id we run the build locally skip the setup
if [[ "$EAS_BUILD_RUNNER" == "local-build-plugin" ]]; then
 echo "The build is being ran locally"
 echo "Skipping the GitHub SSH key setup"
 exit 0
fi

# Creat the $HOME/.ssh directory
mkdir -p ~/.ssh

# Restore private key from env variable and generate public key
umask 0177
echo "$GITHUB_SSH_KEY" | base64 -d > ~/.ssh/id_rsa
umask 0022
ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub

# Add GitHub to the known hosts
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Set up Git user name and email
git config --global user.name $GIT_USER_NAME
git config --global user.email $GIT_USER_EMAIL
