## Environment Repo
This repo is a collection of aliases and functions used to normailize my workflow across linux machines. currently only using bash to limit dependencies and also not using anything distro-specific (i.e. package-manager, etc) for compatibility.  
## Organization
The 'aliases' file is sourced by the user's .rc file. This file lists a set of generic aliases (mostly shorthands; i.e. 'e for exit') as well as a function to detect and source '.al' files within the 'env' folder. `.al` files are a way to group application specific aliases and functions together so that they can be included/excluded together, separate from other applications.

## Current `.al` files list
### opt.al
`opt.al` is named after the `/opt` UNIX convention which is reserved for software not part of the distro. `opt.al` defines a convention for installing software in terms of location, aliasing, and version switching: 
 - software should be installed in the $opt_root which is by default `/opt`, 
 - a folder should be created using the `mkdiropt` command for each individual software, the different versions of the   particular software is kept in this folder,
 - the version currently in use is defined by using the `verset <version-subfolder>` command which will create a softlink `cur` pointing to the 'current' version. The corresponding alias used to use the software in `opt.al` should point to this softlink for easy version switching/updating.

The plan is to include a few more functions that will automate the referencing and downloading of software like java, python, etc, to replace the use of package managers. Not relying on package managers has the advantage (if done right) of getting the latest versions straight from the source as well as being distro-independant.

### func.al
`func.al` is a set of custom functions to simplify common operations on the command line:
#### smart cd
- `cd` has been overridden to allow 'jumping'. It works by holding a map of 'directory alaises' in the `cdas` file. Users can add a directory alias using `acd <alias-name>` while in the directory they want to alias.
- once an alias is set the user can use `cd <alias-name>` from any directory. Note that current sub-directories take presidence over aliases; if a current sub-directory has the same name as an alias then your cd command will bring you to the sub-dir.
- the `cdas` map is in the format `<alias-name>:<absolute-path>` and can be edited manually using the `ncd` command.

#### other functions
- `deb <package.deb>` installs a debian package from the command line
- (comming soon): `hoa <network-name>` command to add a specific set of IP ailiases to the `/etc/hosts` file (alternative to setting a local DNS).

### git.al
- various git aliases to make cli use of git quicker.
- in order to use git-autocomplete with these aliases use `ctrl+alt+E` to expand the alias.
- (comming soon): `gi <project-types>...` command to auto-generate standardized gitignore files based on a project's libraries and tools used.

## installation 
Use install script:

```sh
curl https://raw.githubusercontent.com/rbi13/env/master/install.sh | sh
```

which will perform the following:

##aliases
```sh
echo "source ~/env/aliases" >> ~/.bashrc
```
