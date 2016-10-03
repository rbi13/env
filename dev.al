## Function list
# Dockerized dev tools
#
## TODO
##

# sublime-text
alias sublime="dr -it \
  -w ~/ \
  -e DISPLAY=$DISPLAY \
  -e NEWUSER=$USER \
  -e LANG=en_US.UTF-8 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ~/.config/sublime-text-3:$HOME/.config/sublime-text-3 \
  jess/sublime-text-3
"

# Chrome
alias chrome="dr -it \
	--net host \
	--cpuset-cpus 0 \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-e DISPLAY=unix$DISPLAY \
	-v ~/Downloads:/root/Downloads \
	-v ~/.config/google-chrome/:/data \
	--device /dev/snd \
	-v /dev/shm:/dev/shm \
	--name chrome \
	jess/chrome
"
