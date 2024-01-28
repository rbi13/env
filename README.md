
# Environment Repo
## Desciption
This repo is a collection of aliases and functions used to normailize my workflow across linux machines. currently only using bash to limit dependencies and also not using anything distro-specific (i.e. package-manager, etc) for compatibility.

## Content
- [Environment Repo](#environment-repo)
  - [Desciption](#desciption)
  - [Content](#content)
  - [How it works](#how-it-works)
    - [Organization](#organization)
    - [installation](#installation)


## How it works
### Organization
The 'aliases' file is sourced by the user's .rc file. This file lists a set of generic aliases (mostly shorthands; i.e. 'e for exit') as well as a function to detect and source '.al' files within the 'env' folder. `.al` files are a way to group application specific aliases and functions together so that they can be included/excluded together, separate from other applications.

### installation
Use install script:

```sh
curl https://raw.githubusercontent.com/rbi13/env/master/install.sh | sh
```


