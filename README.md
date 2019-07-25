## Environment Repo
This repo is a collection of aliases and functions used to normailize my workflow across linux machines. currently only using bash to limit dependencies and also not using anything distro-specific (i.e. package-manager, etc) for compatibility.  
## Organization
The 'aliases' file is sourced by the user's .rc file. This file lists a set of generic aliases (mostly shorthands; i.e. 'e for exit') as well as a function to detect and source '.al' files within the 'env' folder. `.al` files are a way to group application specific aliases and functions together so that they can be included/excluded together, separate from other applications.

## installation
Use install script:

```sh
curl https://raw.githubusercontent.com/chris-jaques/env/master/install.sh | sh
```

which will checkout this repo into the user's home folder and perform the following:

```sh
echo "source ~/env/aliases" >> ~/.bashrc
```

NOTE: if the aliases aren't available on shell re-launch, check to see if your .bashrc is being sourced by your .profile.
