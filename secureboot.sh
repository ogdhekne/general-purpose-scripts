#!/bin/bash
# install / add / start / stop / enable / disable secureboot.

# ENV:
    # secureboot signing keys location:
    export loc="/opt/secureboot"

    # signing module name: ex: vboxdrv / acpi-call
    export modulename="$2"

# FUNC:
    
    install()
    {
        # install required packages:
        sudo apt install -y mokutil openssl
    }


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

    enable()
    {
        # enable secureboot validation:
        sudo mokutil --enable-validation
    }

    disable()
    {
        # disable secureboot validation:
        sudo mokutil --disable-validation
    }

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

            echo "Signing key enrollment status: $(mokutil --test-key $loc/MOK.der)"

            echo ""

            # check module is signed:
            echo "Module signing status: $(tail $(modinfo -n $modulename) | grep "Module signature appended")"           

        fi
    }

    help()
    {
        cat <<EOF
        +-----------------------------------------+
        +     Secure boot key signing utility     +
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

# EXEC:
    # If no commandline argument is passed then print help.
    if [[ -z $1 ]]
    then
        help
    else
        $1
    fi