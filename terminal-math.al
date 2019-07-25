#!/bin/bash
#
# Terminal Math
#
#

i-math(){
    sudo apt-get update && sudo apt-get install python3 xclip
    dev
    git clone https://github.com/chris-jaques/terminal-math.git
    cd terminal-math
    ln -s $(pwd)/terminal-math.py ~/terminal-math.py
}

m(){
    # Execute math function and copy results to clipboard
    python3 ~/terminal-math.py ${@:1} | cbcopy;

    # Output results to terminal
    cbpaste;
    
    # Echo for a new line
    echo "";
}