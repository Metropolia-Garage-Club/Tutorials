#! /bin/bash

# Defining colour variables for colourful output
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'

# Check not running as root
if [ "$EUID" == 0 ]
    then echo -e "$RED Running as root..."
         echo -e " Run the script as a regular user $NC"
    exit
fi

# source os-relese to get distro information
source /etc/os-release
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
    apt|nala) echo -e "Using a $BLUE Debian $NC based system with packager: " $BLUE $PKGER $NC
    ;;
    pacman) echo -e "$BLUE Arch $RED isn't supported as of yet $NC"
            echo -e "You are using: " $BLUE $PKGER $NC
            exit 1
    ;;
    *) echo -e "$RED You are not using a supported package manager $NC"
        exit 1
    ;;
esac

# Start by installing package manager if needed
if [[ "$PKGER" != "pacman" && "$PKGER" != "nala" ]];
then
    read -p "Do you want to use nala as Package Manager? [Y]/[n] " yn1
 case "$yn1" in
    [Yy]* ) sudo apt install nala -y; PKGER=nala;;
    [Nn]* ) ;;
        * ) sudo apt install nala -y; PKGER=nala;;
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
# Flatpak
sudo $PKGER install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# gnome-software && gnome-shell-extension-manager
sudo $PKGER install gnome-software gnome-software-plugin-flatpak -y
sudo $PGKER install gnome-shell-extension-manager -y

# miniconda
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
# sudo $PKGER install npm -y
# sudo $PKGER install cargo -y
}

## Dev Tools
install_dev_tools()
{
CONTAINERS=1
sudo $PKGER install tealdeer -y; tldr --update
sudo $PKGER install arduino -y
sudo $PKGER install git -y
# sudo $PKGER install docker-desktop -y
sudo $PKGER install nvim -y
sudo $PKGER install gh -y
sudo $PKGER install github-desktop -y
sudo $PKGER install tesseract-ocr-eng tesseract-ocr-fin -y
sudo $PKGER install nvidia-cuda-toolkit nvidia-cuda-samples -y
# sudo $PKGER install opencv -y
# sudo $PKGER install netbird -y
# sudo $PKGER install qemu-full -y
# sudo $PKGER install wine -y

# Kubernetes

# Podman

# Docker
case "$ID" in
    "arch") ;;
    "ubuntu") sudo install -m 0755 -d /etc/apt/keyrings \
            sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
            sudo chmod a+r /etc/apt/keyrings/docker.asc \
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
              ${UBUNTU_CODENAME:-$VERSION_CODENAME} stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
            sudo $PKGER update
            sudo $PKGER install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        ;;
    "debian") sudo install -m 0755 -d /etc/apt/keyrings \
            sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
            sudo chmod a+r /etc/apt/keyrings/docker.asc \
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
              $VERSION_CODENAME stable" | \
              sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
            sudo $PKGER update
            sudo $PKGER install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
        ;;
esac

}

## Robot Simulation
install_robot_simulation()
{
# TODO: Add install scripts for isaac-sim && -lab
# sudo $PKGER install ROS2 -y

# isaacsim
ISAAC_SIM_DL_4_2="https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone%404.2.0-rc.18%2Brelease.16044.3b2ed111.gl.linux-x86_64.release.zip"
ISAAC_SIM_DL_4_5="https://download.isaacsim.omniverse.nvidia.com/isaac-sim-comp-check%404.5.0-rc.6%2Brelease.675.f1cca148.gl.linux-x86_64.release.zip"
ISAAC_SIM_DL_5_0=""

echo -e "\nAvailable IsaacSim versions are: $YELLOW
1) 4.2
2) 4.5
3) 5.0 (in beta as of 7/2025) $NC"
read -p "Select which version of IsaacSim to install (1 - 3): " isac_sim_version

mkdir -p ~/isaacsim
cd ~/isaacsim

case "$isaac_sim_version" in
    1 ) wget -P ~/isaacsim $ISAAC_SIM_DL_4_2; \
        unzip "~/isaacsim/isaac-sim-*.zip"; \
        ./omni.isaac.sim.post.install.sh:; \
        cd;;

    2 ) wget -P ~/isaacsim $ISAAC_SIM_DL_4_5; \
        unzip "~/isaacsim/isaac-sim-*.zip"; \
        ./post_install; \
        cd;;
    3 ) wget -P ~/isaacsim $ISAAC_SIM_DL_5_0; \
        unzip "~/isaacsim/isaac-sim-*.zip"; \
        ./post_install; \
        cd;;
    * ) echo -e "$RED Unknown IsaacSim version $isaac_sim_version"
esac

# IsaacLab
mkdir -p ~/IsaacLab


# sudo $PKGER install unity -y
# [drone_sim]
return
}

## CAD Software
install_cad_software ()
{
flatpak install --from https://flathub.org/repo/appstream/org.kicad.KiCad.flatpakref -y
# sudo $PKGER install kicad kicad-packages3d -y
sudo flatpak install --user org.freecad.FreeCAD -y #appimg or flatpak
sudo $PKGER install octave -y
# sudo $PKGER install blender -y

}

## 3D Printing
install_3d_printing ()
{
ORCA_LATEST_TAG=$(curl -s https://api.github.com/repos/SoftFever/OrcaSlicer/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
ORCA_DOWNLOAD_URL="https://github.com/SoftFever/OrcaSlicer/releases/download/$ORCA_LATEST_TAG/OrcaSlicer_Linux_AppImage_$ORCA_LATEST_TAG.AppImage"
mkdir -p ~/AppImages
wget -P ~/AppImages/ "$ORCA_DOWNLOAD_URL"
chmod +x ~/AppImages/OrcaSlicer_*.AppImage
# flatpak install --user io.mango3d.LycheeSlicer -y
# flatpak install --user com.prusa3d.PrusaSlicer -y
# flatpak install --user com.ultimaker.cura -y
# flatpak install --user com.bambulab.BambuStudio -y
}

# System Utils
install_system_utils()
{
sudo $PKGER install libfuse2 -y
sudo $PKGER install timeshift -y
sudo $PKGER install curl -y
}

# Flatpaks
install_flatpaks()
{
if command -v flatpak >/dev/null 2>&1
then
flatpak install --user com.obsproject.Studio -y  #Official obs pkg
flatpak install --user com.github.tchx84.Flatseal -y #Flatpak pkg permissions manager
flatpak install --user eu.stethewwolf.gresistor -y #GUI for checking THT resistor colour codes
flatpak install --user com.moonlight_stream.Moonlight -y
# flatpak install --user com.usebottles.bottles -y
# flatpak install --user us.zoom.Zoom -y
# flatpak install --user com.discordapp.Discord -y
# flatpak install --user org.upscayl.Upscayl
fi
}

# Snap packages
install_snaps()
{
if command -v snap >/dev/null 2>&1
then
    sudo snap install --classic code
    sudo snap install --classic google-cloud-cli
    echo -e "$BLUE vs code $NC installed through $BLUE Snap $NC"
else
    echo -e "$BLUE Snap $RED not available, $NC skipping $BLUE Snap packages... $NC"
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
 9) 3D Printing (OrcaSlicer, LycheeSlicer, PrusaSlicer, Cura, BambuStudio)
 10) Flatpaks (OBS, FreeCAD, Flatseal, gResistor)
 11) Snap packages (gcloud-cli, vscode)
 12) System Utils (timeshift, libfuse2) \n $NC"
read -p "Select what category of packages to install (0 - 12): " pkglist

###############################
# !! PKGS installation start !!
###############################
case "$pkglist" in
    0 ) install_system_utils; install_resource_monitors; install_terminal_emulators; \
        install_file_managers; install_document_viewers; install_package_managers; \
        install_dev_tools; install_robot_simulation; install_cad_software; install_3d_printing; \
        install_flatpaks; install_snaps;;
    1 ) install_resource_monitors ;;
    2 ) install_terminal_emulators ;;
    3 ) install_file_managers ;;
    4 ) install_document_viewers ;;
    5 ) install_package_managers ;;
    6 ) install_dev_tools ;;
    7 ) install_robot_simulation ;;
    8 ) install_cad_software ;;
    9 ) install_3d_printing ;;
    10 ) install_flatpaks ;;
    11) install_snaps ;;
    12) install_system_utils ;;
    * ) echo -e "$RED Nothing to install... $NC"; exit 1;;
esac
