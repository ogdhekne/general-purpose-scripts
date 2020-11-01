#!/bin/bash
#---------------------------------------------------------------------------------------------------------------#
# install / add / start / stop / enable / disable secureboot.                                                   #
# This script is licenced under GPLv3 ; you can get your copy from https://www.gnu.org/licenses/gpl-3.0.en.html #
# (C) Omkar Dhekne ; ogdhekne@yahoo.in ; github: https://github.com/ogdhekne                                    #
#---------------------------------------------------------------------------------------------------------------#

# Environment variables:
    # secureboot signing keys location:
    export loc="/opt/secureboot"

    # signing module name: ex: vboxdrv / acpi-call
    export modulename="$2"

# Functions:
    
    # Install required packages:
    install()
    {
        # install required packages:
        sudo apt install -y mokutil openssl
    }

    # Add signing secure boot signing keys:
    add()
    {   
        # if module name is not added key signing commands will not execute.
        if [ -z "$modulename" ]
        then
            echo "Module name is missing, please try again after adding module name. "
        else 

            # create signing key location:
            sudo mkdir $loc

            # provide user owner permission to signing key location:
            sudo chown -R $USER: $loc

            # create signing keys:
            openssl req -new -x509 -newkey rsa:2048 -keyout $loc/MOK.priv -outform DER -out $loc/MOK.der -nodes -days 36500 -subj "/CN=$(hostname)/"

            # sign module:
            sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 $loc/MOK.priv $loc/MOK.der $(modinfo -n $modulename)

            # check module is signed:
            tail $(modinfo -n $modulename) | grep "Module signature appended"

            # register signing key:
            sudo mokutil --import $loc/MOK.der

        fi
    }

    # Sign module:
    signmodule()
    {
        # if module name is not added key signing commands will not execute.
        if [ -z "$modulename" ]
        then
            echo "Module name is missing, please try again after adding module name. "
        else 

            # sign module:
            sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha256 $loc/MOK.priv $loc/MOK.der $(modinfo -n $modulename)

            # check module is signed:
            tail $(modinfo -n $modulename) | grep "Module signature appended"

            # register signing key:
            sudo mokutil --import $loc/MOK.der
        fi
    }

    # Enable secure boot:
    enable()
    {
        # enable secureboot validation:
        sudo mokutil --enable-validation
    }

    # Disable secure boot:
    disable()
    {
        # disable secureboot validation:
        sudo mokutil --disable-validation
    }

    # Check secure boot status:
    status()
    {
        # if module name is not added key signing commands will not execute.
        if [ -z "$modulename" ]
        then
            echo "Module name is missing, please try again after adding module name. "
        else

            # check secureboot status
            echo "SecureBoot status: $(sudo mokutil --sb-state)"
            
            # just blank line
            echo ""

            # signing key enrollment status
            echo "Signing key enrollment status: $(mokutil --test-key $loc/MOK.der)"

            echo ""

            # check module is signed:
            echo "Module signing status: $(tail $(modinfo -n $modulename) | grep "Module signature appended")"           

        fi
    }

    # Print this help:
    help()
    {
        cat <<EOF
        +-----------------------------------------+
        +     Secure boot key signing utility     +
        +-----------------------------------------+

./secureboot.sh install                     :   Install required packages for secure boot key signing.
./secureboot.sh add <module name>           :   Creates, signs, registers keys.
./secureboot.sh signmodule <module name>    :   Signs and registers keys.
./secureboot.sh enable                      :   Enables secure boot.
./secureboot.sh disable                     :   Disables secure boot.
./secureboot.sh status <module name>        :   Display status of secure boot and module signing.
./secureboot.sh help                        :   Print this help.

Examples:
./secureboot.sh add vboxdrv
./secureboot.sh signmodule acpi-call
./secureboot.sh status vboxdrv
EOF
    }

# Execute functions:
    # If no commandline argument is passed then print help.
    if [[ -z $1 ]]
    then
        help
    else
        $1
    fi