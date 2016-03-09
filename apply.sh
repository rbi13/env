#!/bin/sh

# clone environment repo
cd ~/
git clone https://github.com/rbi13/env.git

# apply environment

# add aliases to user's rc
echo "source ~/env/aliases" >> ~/.bashrc

# setup host
sudo cp ~/env/hosts /etc/hosts
