#!/bin/bash
#---------------------------------------------------------------------------------------------------------------#
# install / service / config for Open Streaming Platform as single-node environment.                            #
# This script is licenced under GPLv3 ; you can get your copy from https://www.gnu.org/licenses/gpl-3.0.en.html #
# (C) Omkar Dhekne ; ogdhekne@yahoo.in ; github: https://github.com/ogdhekne                                    #
#---------------------------------------------------------------------------------------------------------------#

# -- Environment variables:

    # -- Colors:
	export RESET="\e[0m"
	export GRAY="\e[100m"

    # -- Network
    export IP=$(ip addr show dev `route -n | awk 'NR==3{print $8}'` | grep "inet " | awk '{print $2}' |  cut -d'/' -f 1)
    export HOST="" # Change HOST here as FQDN : server.example.com
    export AHOST=$(echo $HOST | cut -d'.' -f 1)

    export PASS=""
    

    # -- SSL
    export SSLPATH="/opt/ssl/"
    export CERTDETAILS="IN
    MH
    PUNE
    OMNEPRESENT TECHNOLOGUES PVT. LTD.
    ONLINE TRAINING
    OSPDEV
    ogdhekne@yahoo.in
    "


# -- Functions:

    # -- Install dependencies and open streaming platform with or without ssl certificates.
    install()
    {
        sudo apt update && sudo apt upgrade -y

        sudo apt install curl git dialog htop tmux mariadb-server -y

        git clone git clone https://gitlab.com/Deamos/flask-nginx-rtmp-manager.git

        mkdir -v ~/osp_data

        cat >> ~/osp_data/hosts << EOF
        127.0.0.1       localhost

        # The following lines are desirable for IPv6 capable hosts
        ::1     ip6-localhost ip6-loopback
        fe00::0 ip6-localnet
        ff00::0 ip6-mcastprefix
        ff02::1 ip6-allnodes
        ff02::2 ip6-allrouters

        # FQDN for Open Streaming Platform:
        $IP     $HOST       $AHOST

EOF

    cat >> ~/osp_data/hostname << EOF
    $HOST
EOF

    sudo hostname $HOST

    cd flask-nginx-rtmp-manager/

    chmod +x osp-config.sh


        ssl()
        {
            sudo mkdir -pv $SSLPATH/private

            sudo chmod -R 700 $SSLPATH/private

            sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $SSLPATH/private/osp-private.key -out $SSLPATH/private/osp-private.crt <<EOF
            $CERTDETAILS
EOF            
            sudo openssl dhparam -out $SSLPATH/private/dhparam.pem 2048

            cat ~/osp_data/nginx.conf <<EOF
                user  www-data;
                worker_processes  auto;

                pid        /run/nginx.pid;

                events {
                    worker_connections  1024;
                    multi_accept        on;
                    use                 epoll;
                }

                http {
                    include       mime.types;
                    default_type  application/octet-stream;

                    proxy_cache_path    /tmp levels=1:2 keys_zone=auth_cache:5m max_size=1g inactive=24h;

                    sendfile        on;
                    tcp_nopush      on;
                    gzip            on;
                    gzip_comp_level    5;
                    gzip_min_length    256;
                    gzip_proxied       any;
                    gzip_vary          on;

                    gzip_types
                    application/atom+xml
                    application/javascript
                    application/json
                    application/ld+json
                    application/manifest+json
                    application/rss+xml
                    application/vnd.geo+json
                    application/vnd.ms-fontobject
                    application/x-font-ttf
                    application/x-web-app-manifest+json
                    application/xhtml+xml
                    application/xml
                    font/opentype
                    image/bmp
                    image/svg+xml
                    image/x-icon
                    image/gif
                    image/png
                    video/mp4
                    video/mpeg
                    video/x-flv
                    text/cache-manifest
                    text/css
                    text/plain
                    text/vcard
                    text/vnd.rim.location.xloc
                    text/vtt
                    text/x-component
                    text/x-cross-domain-policy;


                    keepalive_timeout  65;

                    include /usr/local/nginx/conf/upstream/*.conf;
                    include /usr/local/nginx/conf/servers/*.conf;

                    # NGINX to HTTP Reverse Proxies
                    server {
                        listen 80;
                        server_name _;
                        return 301 https://$host$request_uri;
                    }


                    server {
                        listen 443 ssl http2 default_server;
                        server_name _;

                        ssl_certificate $SSLPATH/private/osp-private.crt;
                        ssl_certificate_key $SSLPATH/private/osp-private.key;
                        ssl_dhparam $SSLPATH/private/dhparam.pem;

                        # set client body size to 16M #
                        client_max_body_size 16M;

                        include /usr/local/nginx/conf/locations/*.conf;

                        # redirect server error pages to the static page /50x.html
                        error_page   500 502 503 504  /50x.html;
                        location = /50x.html {
                            root   html;
                        }
                    }
                }

                include /usr/local/nginx/conf/services/*.conf;
EOF

            sudo systemctl restart nginx-osp.service

            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }

        nossl()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }

        letsencrypt()
        {
            sudo apt update && sudo apt install software-properties-common -y

            sudo add-apt-repository universe

            sudo add-apt-repository ppa:certbot/certbot <<EOF

EOF

            sudo apt update && sudo apt install certbot -y

            sudo mkdir -pv $SSLPATH/certbot

            

            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }
    }

    # -- Update already installed Open Streaming Platform application as well as other components.
    update()
    {
        cd flask-nginx-rtmp-manager/
    
        sudo ./osp-config.sh upgrade

        sudo ./osp-config.sh dbupgrade

        echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		read enter
    }



    # -- Start / Stop / Status / Restart OSP services.
    service()
    {
        start()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }

        stop()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }

        status()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }

        restart()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }
    }

    # -- Configure perticular service.
    config()
    {
        create()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }

        edit()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }

        reset()
        {
            echo -e "\n Press ${GRAY:-} [Enter] ${RESET:-} to exit. \n"
		    read enter
        }
    }

    # -- Print this help.
        help()
        {
            cat << EOF
            +---------------------------------------------------+
            +     Open Streaming Platform management utility    +
            +---------------------------------------------------+

    ./osp.sh install (ssl/nossl/letsencrypt)           :   Install dependencies and open streaming platform 
                                                            with or without ssl certificates.
    ./osp.sh service (start/stop/status/restart)       :   Start / Stop / Status / Restart OSP services.
    ./osp.sh config  (create/edit/reset)               :   Configure perticular service.
    ./osp.sh help                                      :   Print this help.
EOF
        }

# -- Execute functions:
    # -- If no commandline argument is passed then print help.
    if [[ -z $1 ]]
    then
        help
    else
        $1 ; $2
        #tmux new-session -s osp_installer '$0 ; $1 ; $2';
    fi