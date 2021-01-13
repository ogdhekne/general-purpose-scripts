#!/bin/bash
#---------------------------------------------------------------------------------------------------------------#
# install / add / start / stop / enable / disable secureboot.                                                   #
# This script is licenced under GPLv3 ; you can get your copy from https://www.gnu.org/licenses/gpl-3.0.en.html #
# (C) Omkar Dhekne ; ogdhekne@yahoo.in ; github: https://github.com/ogdhekne                                    #
#---------------------------------------------------------------------------------------------------------------#

    # Install required packages:
    install()
    {
        # Install required packages:
        sudo apt install tlp tlp-rdw acpi-call acpi -y
    }

    # Print this help:
    help()
    {
        cat <<EOF
        +-----------------------------------------+
        +    Laptop battery management utility    +
        +-----------------------------------------+

./secureboot.sh install                 :   Install required packages for secure boot key signing.
./secureboot.sh add <modulename>        :   Creates, signs, registers keys.
./secureboot.sh signmodule <modulename> :   Signs and registers keys.
./secureboot.sh enable                  :   Enables secure boot.
./secureboot.sh disable                 :   Disables secure boot.
./secureboot.sh status                  :   Display status of secure boot and module signing.
./secureboot.sh help                    :   Print this help.

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