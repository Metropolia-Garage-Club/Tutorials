#!/bin/bash

## Defining colour variables for colourful output
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'

## Check not running as root
if [ "$EUID" == 0 ]
    then echo -e "$RED Running as root..."
         echo -e " Run the script as a regular user $NC"
    exit
fi

## Define common variables and paths used for the script
ACTIVE_USER_HOME="/home/${USER}"
SKEL_PATH="$ACTIVE_USER_HOME/Documents/Guides/Tutorials/debian_setup/skel"
GROUPS_ARRAY=("users" "dialout" "garage")
GROUPS_LIST=$(IFS=, ; echo "${GROUPS_ARRAY[*]}")
TEST=true

## Create a user and add to desired groups
read -p "Enter a name for the new user: " USER_NAME

## add the following lines to make user expire after a set date
# echo -e "$YELLOW User expiredate is of the form: $BLUE YYYY-MM-DD $YELLOW If left blank, user won't be automatically deleted $NC"
# read -p "Enter an expiredate for the user (optional): " USER_EXPIRE

sudo useradd "$USER_NAME" --create-home --skel "$SKEL_PATH"

## Check if groups already exist, then add user to those groups
for groups in "${GROUPS_ARRAY}"
do
    if [ -n "$groups" ]; then

       getent group "$groups" >/dev/null || sudo groupadd "$groups"
    fi
done

sudo usermod -aG "$GROUPS_LIST" "$USER_NAME"

## Test print to make sure the user's home directory contents as well as groups the user is in are correct
if [[ $TEST == "true" ]]; then
    echo -e "\n $BLUE $USER_NAME $YELLOW home directory contents: $NC"
    sudo ls -la /home/"$USER_NAME"

    echo -e "\n $BLUE $USER_NAME $YELLOW groups: $NC"
    sudo groups "$USER_NAME"
fi
