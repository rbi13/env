#!/bin/sh

# apply environment

## TODO: check if already written before appending again OR 
## version rc file completely
# add aliases to user's rc
echo "source ~/env/aliases" >> ~/.bashrc
