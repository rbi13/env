#!/bin/bash

i-interactivebrokers(){
  url="https://download2.interactivebrokers.com/installers/tws/latest/tws-latest-linux-x64.sh"
  curl -Ls  ${url} > ibtrader.sh
  chmod u+x ibtrader.sh
  ./ibtrader.sh
  rm ibtrader.sh
}
