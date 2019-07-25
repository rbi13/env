#!/bin/bash
#
# Web Browser Aliases
#
#

# Install Chrome Browser
i-chrome(){
    cd ~/Downloads
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
}

# Google Search {searchString}
alias goo="open https://www.google.com/search?q="

# SuperLIFT Invoice Breakdown {invoiceNumber}
alias inv="open https://superlift.theliftsystem.com/invoices/breakdown/"

# Docker Hub Search {search}
alias dh="open https://hub.docker.com/search?q="

# Docker hub Lucky Search {search}
alias dhl="open https://hub.docker.com/_/"

# explain Shell {cmd}
alias xsh='open https://explainshell.com/explain?cmd='