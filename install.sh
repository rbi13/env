#!/bin/sh

# clone environment repo
cd ~/
git clone https://github.com/rbi13/env.git
# git clone git@github.com:rbi13/env.git

# apply environment
sh ~/env/apply.sh
echo "source ~/env/aliases" >> ~/.bashrc