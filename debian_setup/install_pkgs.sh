#!/bin/bash

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

# source os-release to get distro information
source /etc/os-release
PROCESSOR_ARCH=$(uname -m)

# Checking Package Manager
if command -v nala >/dev/null 2>&1
then
    PKGER=nala

elif command -v apt >/dev/null 2>&1
then
    PKGER=apt

elif command -v yay >/dev/null 2>&1
then
    PKGER=yay

elif command -v paru >/dev/null 2>&1
then
    PKGER=paru

elif command -v pacman >/dev/null 2>&1
then
    PKGER=pacman

else
    PKGER=" "
    echo "you seem to not be using a Debian or Arch based distro :/"
    #echo "packages are installed with: " $PKGER
    exit 1
fi

case "$PKGER" in
    apt|nala) echo -e "Using a $BLUE Debian $NC based system with packager: " $BLUE $PKGER $NC
            # if apt is the current $PKGER, offer to switch to using nala
            if [[ "$PKGER" == "apt" ]]; then
                if command -v nala >/dev/null 2>&1; then
                    read -p "Nala is available. Use nala instead of apt? [Y]/[n] " yn1
                    case "$yn1" in
                        [Yy]*) PKGER=nala ;;
                        [Nn]*) ;;
                        *) PKGER=nala ;;
                    esac

                fi

                read -p "Do you want to use nala as the system Package Manager? [Y]/[n] " yn2
                case "$yn2" in
                    [Yy]*) sudo apt install nala; PKGER=nala ;;
                    [Nn]*) ;;
                    *) sudo apt install nala; PKGER=nala ;;
                esac
            fi
            ;;

    pacman|yay|paru) echo -e "Using an $BLUE Arch $NC based system with packager: " $BLUE $PKGER $NC
            # if pacman is the current $PKGER, offer to switch to yay / paru (AUR Helper)
            if [[ "$PKGER" == "pacman" ]]; then
                if command -v yay >/dev/null 2>&1; then
                    read -p "Yay is available. Use yay instead of pacman? [Y]/[n] " yn3
                    case "$yn3" in
                        [Yy]*) PKGER=yay ;;
                        [Nn]*) ;;
                        *) PKGER=yay ;;
                    esac
                elif command -v paru >/dev/null 2>&1; then
                    read -p "Paru is available. Use paru instead of pacman? [Y]/[n] " yn4
                    case "$yn4" in
                        [Yy]*) PKGER=paru ;;
                        [Nn]*) ;;
                        *) PKGER=paru ;;
                    esac
                else
                    # Neither yay nor paru available - offer to install yay, then offer paru
                    read -p "Do you want to install yay (AUR helper) as system Package Manager? [Y]/[n] " yn5
                    case "$yn5" in
                        [Yy]*)
                            # Install yay
                            sudo pacman -S --needed git base-devel --noconfirm
                            cd /tmp
                            git clone https://aur.archlinux.org/yay.git
                            cd yay
                            makepkg -si --noconfirm
                            cd
                            PKGER=yay
                            ;;

                        [Nn]*)
                            # User declined yay, offer paru
                            read -p "Do you want to install paru (AUR helper) as system Package Manager instead? [Y]/[n] " yn6
                            case "$yn6" in
                                [Yy]*)
                                    # Install paru
                                    sudo pacman -S --needed git base-devel --noconfirm
                                    cd /tmp
                                    git clone https://aur.archlinux.org/paru.git
                                    cd paru
                                    makepkg -si --noconfirm
                                    cd
                                    PKGER=paru
                                    ;;

                                [Nn]*) echo -e "Continuing with pacman (some AUR packages may not be available)" ;;
                                *)
                                    # Default to installing paru
                                    sudo pacman -S --needed git base-devel --noconfirm
                                    cd /tmp
                                    git clone https://aur.archlinux.org/paru.git
                                    cd paru
                                    makepkg -si --noconfirm
                                    cd
                                    PKGER=paru
                                    ;;
                        esac
                        ;;
                    *)
                        # Default to installing yay
                        sudo pacman -S --needed git base-devel --noconfirm
                        cd /tmp
                        git clone https://aur.archlinux.org/yay.git
                        cd yay
                        makepkg -si --noconfirm
                        cd
                        PKGER=yay
                        ;;
                    esac
                fi
            fi
            ;;
    *) echo -e "$RED You are not using a supported package manager $NC"
        exit 1 ;;
esac

# function to find the latest version number of a GitHub release
# example use: $repo_path=arduino/arduino-ide
get_github_latest_release_tag()
{
local repo_path="$1"
curl -s "https://api.github.com/repos/$repo_path/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'
}

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

# Snap
# sudo $PKGER install snap -y

# gnome-software && gnome-shell-extension-manager
if pgrep -x "gnome-shell" > /dev/null; then
    sudo $PKGER install gnome-software gnome-software-plugin-flatpak -y
    sudo $PKGER install gnome-shell-extension-manager -y
fi

# miniconda
if ! command -v conda >/dev/null 2>&1; then
    mkdir -p ~/miniconda3
    wget -P ~/miniconda3 "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
fi

# sudo $PKGER install npm -y
# sudo $PKGER install cargo -y
}

## Dev Tools
install_dev_tools()
{
    # add user to dialout (debian) or uucp (arch) group to be able to communicate with microcontrollers
if [[ "$ID" == "arch" ]]; then
    sudo usermod -aG uucp $USER
else
    sudo usermod -aG dialout $USER
fi

sudo $PKGER install tealdeer -y; tldr --update
sudo $PKGER install git -y
sudo $PKGER install nvim -y
sudo $PKGER install gh -y
sudo $PKGER install jq -y
sudo $PKGER install tesseract-ocr-eng tesseract-ocr-fin -y
sudo $PKGER install nvidia-cuda-toolkit nvidia-cuda-samples -y
# sudo $PKGER install arduino -y
# sudo $PKGER install github-desktop -y
# sudo $PKGER install docker-desktop -y
# sudo $PKGER install opencv -y  # Python package
# sudo $PKGER install netbird -y
# sudo $PKGER install wine -y

# Arduino IDE
local repo_path="arduino/arduino-ide"
ARDUINO_LATEST_TAG=$(get_github_latest_release_tag "$repo_path")
ARDUINO_DOWNLOAD_URL="https://github.com/$repo_path/releases/download/$ARDUINO_LATEST_TAG/arduino-ide_${ARDUINO_LATEST_TAG}_Linux_64bit.AppImage"

if ! ls ~/AppImages/arduino-ide_*.AppImage 1>/dev/null 2>&1; then
    mkdir -p ~/AppImages
    wget -O ~/AppImages/ $ARDUINO_DOWNLOAD_URL
    chmod +x ~/AppImages/arduino-ide_*.AppImage
fi
# QEMU KVM
# sudo $PKGER install qemu-full -y

# VS Code
if [[ $ID == "ubuntu" || $ID == "debian" || $ID == "linuxmint" || $ID == "pop" ]]; then
    case "$PROCESSOR_ARCH" in
        x86_64) wget -O ~/Downloads/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64";
        sudo $PKGER install ~/Downloads/vscode.deb
        ;;
        arm64) wget -O ~/Downloads/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64";
        sudo $PKGER install ~/Downloads/vscode.deb
        ;;
        *) echo -e "$RED Unknown processor architecture"
        ;;
    esac
fi

}

install_container_tools()
{
# Docker
if ! command -v docker >/dev/null 2>&1; then
    case "$ID" in
        "arch") ;;

        "ubuntu") sudo install -m 0755 -d /etc/apt/keyrings && \
                sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
                sudo chmod a+r /etc/apt/keyrings/docker.asc && \
                echo \
                  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                  ${UBUNTU_CODENAME:-$VERSION_CODENAME} stable" | \
                  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
                sudo $PKGER update && \
                sudo $PKGER install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
            ;;

        "debian") sudo install -m 0755 -d /etc/apt/keyrings && \
                sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
                sudo chmod a+r /etc/apt/keyrings/docker.asc && \
                echo \
                  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
                  $VERSION_CODENAME stable" | \
                  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
                sudo $PKGER update && \
                sudo $PKGER install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
            ;;
    esac
fi

# Kubernetes

# Podman
pod_install=true
if $pod_install; then
    if ! command -v podman >/dev/null 2>&1; then
        sudo $PKGER install podman podman-compose -y
    fi
    }
fi
}
## Robot Simulation
install_robot_simulation()
{
# TODO: Add install scripts for isaaclab, ros2 && unity
# sudo $PKGER install ROS2 -y

# isaacsim
ISAAC_SIM_DL_4_2="https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone%404.2.0-rc.18%2Brelease.16044.3b2ed111.gl.linux-x86_64.release.zip"
ISAAC_SIM_DL_4_5="https://download.isaacsim.omniverse.nvidia.com/isaac-sim-comp-check%404.5.0-rc.6%2Brelease.675.f1cca148.gl.linux-x86_64.release.zip"
ISAAC_SIM_DL_5_0=""

echo -e "\nAvailable IsaacSim versions are: $YELLOW
1) 4.2
2) 4.5
3) 5.0 (in beta as of 7/2025) $NC"
read -p "Select which version of IsaacSim to install (1 - 3): " isaac_sim_version

mkdir -p ~/isaacsim
cd ~/isaacsim

case "$isaac_sim_version" in
    1 ) wget -P ~/isaacsim $ISAAC_SIM_DL_4_2
        unzip "~/isaacsim/isaac-sim-*.zip"
        ./omni.isaac.sim.post.install.sh
        cd
        ;;

    2 ) wget -P ~/isaacsim $ISAAC_SIM_DL_4_5
        unzip "~/isaacsim/isaac-sim-*.zip"
        ./post_install
        cd
        ;;
    3 ) wget -P ~/isaacsim $ISAAC_SIM_DL_5_0
        unzip "~/isaacsim/isaac-sim-*.zip"
        ./post_install
        cd
        ;;
    * ) echo -e "$RED Unknown IsaacSim version $isaac_sim_version $NC"
esac

# IsaacLab
if command -v nvcc >/dev/null 2>&1; then
CUDA_VERSION=$(nvcc --version | grep -oP 'release \K[0-9]+\.[0-9]+')
else
    CUDA_VERSION=" "
    echo -e "$RED Cuda not found!$NC"
fi
mkdir -p ~/IsaacLab

# Unity
# sudo $PKGER install unity -y
# [drone_sim]
return
}

## CAD Software
install_cad_software ()
{
flatpak install --from https://flathub.org/repo/appstream/org.kicad.KiCad.flatpakref -y
# sudo $PKGER install kicad kicad-packages3d -y     # version in ubuntu/debian repos is quite old
sudo flatpak install --user org.freecad.FreeCAD -y #appimg or flatpak
sudo $PKGER install octave -y
# sudo $PKGER install blender -y

}

## 3D Printing
install_3d_printing ()
{
local repo_path="SoftFever/OrcaSlicer"
ORCA_LATEST_TAG=$(get_github_latest_release_tag "$repo_path")
ORCA_DOWNLOAD_URL="https://github.com/$repo_path/releases/download/$ORCA_LATEST_TAG/OrcaSlicer_Linux_AppImage_$ORCA_LATEST_TAG.AppImage"
if ! ls ~/AppImages/OrcaSlicer_*.AppImage 1>/dev/null 2>&1; then
    mkdir -p ~/AppImages
    wget -P ~/AppImages/ "$ORCA_DOWNLOAD_URL"
    chmod +x ~/AppImages/OrcaSlicer_*.AppImage
fi
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
#     sudo snap install --classic code
#     sudo snap install --classic google-cloud-cli
#     echo -e "$BLUE vs code $NC installed through $BLUE Snap $NC"
    echo -e "$RED Are you sure you want to install $BLUE Snap packages? $NC"
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
 3) File Managers (yazi, dolphin, nautilus)
 4) Document Viewers (gimp, libreoffice, VLC, audacity)
 5) Package Managers (flatpak, gnome-software, miniconda, gnome-shell-extension-manager)
 6) Dev Tools (tldr, git, gh, tesseract-ocr, terraform, nvim, arduino-ide, vs-code)
 7) Container Tools (Docker, Podman, Kubernetes)
 8) Robot Simulation (IsaacSim, IsaacLab, ROS2) $YELLOW
 9) CAD (kicad, freecad)
 10) 3D Printing (OrcaSlicer, LycheeSlicer, PrusaSlicer, Cura, BambuStudio)
 11) Flatpaks (OBS, Flatseal, gResistor)
 12) Snap packages (gcloud-cli, vscode)
 13) System Utils (timeshift, libfuse2) \n $NC"
read -p "Select what category of packages to install (0 - 13): " pkglist

###############################
# !! PKGS installation start !!
###############################
case "$pkglist" in
    0 ) install_system_utils; install_resource_monitors; install_terminal_emulators; \
        install_file_managers; install_document_viewers; install_package_managers; \
        install_dev_tools; install_container_tools; install_robot_simulation; \
        install_cad_software; install_3d_printing; install_flatpaks; install_snaps;;
    1 ) install_resource_monitors ;;
    2 ) install_terminal_emulators ;;
    3 ) install_file_managers ;;
    4 ) install_document_viewers ;;
    5 ) install_package_managers ;;
    6 ) install_dev_tools ;;
    7 ) install_container_tools ;;
    8 ) install_robot_simulation ;;
    9 ) install_cad_software ;;
    10 ) install_3d_printing ;;
    11 ) install_flatpaks ;;
    12) install_snaps ;;
    13) install_system_utils ;;
    * ) echo -e "$RED Nothing to install... $NC"; exit 1;;
esac
