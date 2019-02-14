#!/bin/bash
#
# Copyright 2019 Northstrat, Inc.
#

function install_desktop() {
    # apt-get -y groupinstall "X Window System"

    case "${1}" in
    "xfce")
        # Install xfce and virtualbox additions
        sudo apt-get install -y xfce4 virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11
        # Permit anyone to start the GUI
        # sudo touch /etc/X11/Xwrapper.config
        # sudo sed -i 's/allowed_users=.*$/allowed_users=anybody/' /etc/X11/Xwrapper.config
        ;;
    "gnome")
        sudo apt-get install -y gnome-classic-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts gdm
        systemctl enable gdm
        ;;
    *)
        echo "Unknown desktop: $1"
    esac

    systemctl isolate graphical.target
    systemctl set-default graphical.target
}

if [ ! -z "${1}" ]; then
    install_desktop "${1}"
    exit $?
fi
