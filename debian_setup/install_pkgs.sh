#! /bin/bash

# Defining colour variables for colourful output
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'

# Checking Package Manager
if command -v nala >/dev/null 2>&1
then
    PKGER=nala
    # echo "nala is a working command!"
    # echo "you install packages using:" $PKGER

elif command -v apt >/dev/null 2>&1
then 
    PKGER=apt
    # echo "nala is not a command!"
    # echo "you use " $PKGER " to install packages"

elif command -v pacman >/dev/null 2>&1
then 
    PKGER=pacman

else
    PKGER=" "
    # echo "you seem to not be using a Debian based distro :/"
    # echo "packages are installed with: " $PKGER
fi

case "$PKGER" in
    apt|nala) echo -e "Using a $BLUE Debian $NC based system with packager: " $BLUE $PKGER
    ;;
    pacman) echo -e "$BLUE Arch $RED isn't supported as of yet $NC"
            echo -e "You are using: " $BLUE $PKGER $NC
            # exit 1
    ;;
    *) echo -e "$RED You are not using a supported package manager $NC"
        exit 1
    ;;
esac

# Start by installing package manager if needed
if [[ "$PKGER" != "pacman" ]];
then 
    read -p "Do you want to use nala as Package Manager? [Y]/[n] " yn1
 case "$yn1" in
    [Yy]* ) sudo apt install nala -y; PKGER=nala;;
    [Nn]* ) ;;
        * ) ;;
esac
fi



# resource monitors
install_resource_monitors()
{
sudo $PKGER install btop -y
sudo $PKGER install nvtop -y
# sudo $PKGER install wireshark -y   
}

# Terminal emulators
install_terminal_emulators()
{
sudo $PKGER install fish -y

# sudo $PKGER install kitty -y
# sudo $PKGER install alacritty -y
# sudo $PKGER install zsh -y
# sudo $PKGER install foot -y
}

# File Managers
install_file_managers()
{
# sudo $PKGER install dolphin -y
# sudo $PKGER install nautilus -y
## CLI
# sudo $PKGER install ranger -y
# sudo $PKGER install yazi -y
return
}

# Document Viewers
install_document_viewers()
{
sudo $PKGER install gimp -y
sudo $PKGER install vlc -y
sudo $PKGER install libreoffice -y
sudo $PKGER install audacity -y
# sudo $PKGER install imv -y
# sudo $PKGER install zathura -y
}

# Developer
## Package Managers
install_package_managers ()
{
sudo $PKGER install flatpak -y
sudo $PKGER install miniconda -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrep
# sudo $PKGER install npm -y
# sudo $PKGER install cargo -y
}

## Dev Tools
install_dev_tools()
{
sudo $PKGER install tealdeer -y; tldr --update
sudo $PKGER install arduino -y
sudo $PKGER install git -y
sudo $PKGER install docker docker-compose -y
sudo $PKGER install docker-desktop -y
sudo $PKGER install nvim -y
sudo $PKGER install gh -y
sudo $PKGER install github-desktop -y
sudo $PKGER install tesseract -y
sudo $PKGER install opencv -y
# sudo $PKGER install netbird -y
# sudo $PKGER install qemu-full -y
# sudo $PKGER install wine -y


}

## Robot Simulation
install_robot_simulation() 
{
# sudo $PKGER install ROS2 -y
# isaac-sim 
# sudo $PKGER install unity -y
# [drone_sim] 
return
}

## CAD Software
install_cad_software ()
{
sudo $PKGER install kicad kicad-packages3d -y
sudo flatpak install org.freecad.FreeCAD -y #appimg or flatpak
# sudo $PKGER install cura -y #need appimg or use flatpak
sudo $PKGER install octave -y
# sudo $PKGER install blender -y
 
}

# System Utils
install_system_utils()
{
sudo $PKGER install libfuse2 -y
sudo $PKGER install timeshift -y
}

# Flatpaks
install_flatpaks()
{
if command -v flatpak >/dev/null 2>&1
then
flatpak install com.obsproject.Studio -y  #Official obs pkg
flatpak install com.github.tchx84.Flatseal -y #Flatpak pkg permissions manager
flatpak install org.freecad.FreeCAD -y
flatpak install eu.stethewwolf.gresistor -y #GUI for checking THT resistor colour codes
# flatpak install com.bambulab.BambuStudio -y
# flatpak install com.usebottles.bottles -y
# flatpak install us.zoom.Zoom -y
# flatpak install com.discordapp.Discord -y
# flatpak install org.upscayl.Upscayl
fi
}    

# Snap packages
install_snaps()
{
if command -v snap >/dev/null 2>&1
then
    sudo snap install --classic code -y
    sudo snap install --classic google-cloud-cli -y
    echo -e "$BLUE vs code $NC installed through $BLUE Snap $NC"
else 
    echo -e "$BLUE Snap $RED not availabe, $NC skipping $BLUE Snap packages... $NC"
fi
}

###############################
# !! PKGS selection start !! ##
###############################
echo -e "\nAvailable package lists: $YELLOW
 0) All
 1) Resource Monitors (nvtop, btop)
 2) Terminal Emulators (fish)
 3) File Managers ()
 4) Document Viewers (gimp, )
 5) Package Managers ()
 6) Dev Tools ()
 7) Robot Simulation $RED (WIP) $YELLOW
 8) CAD (kicad, freecad, cura)
 9) Flatpaks (OBS, FreeCAD, Flatseal, gResistor)
 10) Snap packages (gcloud-cli, vscode)
 11) System Utils (timeshift, libfuse2) \n $NC"
read -p "Select what category of packages to install (0 - 11): " pkglist

###############################
# !! PKGS installation start !!
###############################
case "$pkglist" in
    0 ) install_resource_monitors; install_terminal_emulators; install_terminal_emulators; \
        install_file_managers; install_document_viewers; install_package_managers; \ 
        install_dev_tools; install_robot_simulation; install_cad_software; install_flatpaks; \
        install_snaps; install_system_utils;; 
    1 ) install_resource_monitors ;; 
    2 ) install_terminal_emulators ;; 
    3 ) install_file_managers ;; 
    4 ) install_document_viewers ;; 
    5 ) install_package_managers ;; 
    6 ) install_dev_tools ;; 
    7 ) install_robot_simulation ;; 
    8 ) install_cad_software ;; 
    9 ) install_flatpaks ;;
    10) install_snaps ;;
    11) install_system_utils ;;
    * ) echo -e "$RED Nothing to install... $NC"; exit 1;;
esac
