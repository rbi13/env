#!/bin/sh

# clone environment repo
cd ~/
git clone https://github.com/chris-jaques/env.git

# apply environment
sh ~/env/apply.sh
