# Guide to this automated Linux software installer

## What is this?
The scripts and pre-made configs in this directory are meant to serve as tools \
to automate setting up Linux machines in the AIoT-Garage, with the secondary \
goal of acting as a tutorial on how to configure Linux environments to your needs.

## How to use
First, before running any random scripts someone else has made, have a look at \
what the script in question does. You don't need to understand everything, but \
try to get and idea of what is going on.

As an example, if you want to install a list of packages using the [install_pkgs.sh](install_pkgs.sh) \
script, open it with your preferred text editor and have a look around.

As always, if you don't know what a particular shell command you found in a script \
or guide does (i.e. the command `read`), you can look it up the command's \
manual page by running: `man read` in a terminal. The **DESCRIPTION** part will explain \
what the purpose of that command is and the **PARAMETERS** section will explain what options \
can be given to that command to alter what the command does.
Searching online for information about a command is also a valid option. \

Now, while looking through a script, like [install_pkgs.sh](install_pkgs.sh), \
feel free to comment / uncomment any package installs, which you do or don't want to do.

## How to modify
