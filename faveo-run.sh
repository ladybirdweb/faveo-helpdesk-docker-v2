#!/bin/bash

# Colour variables for the script.
red=`tput setaf 1`

green=`tput setaf 2`

yellow=`tput setaf 11`

skyblue=`tput setaf 14`

white=`tput setaf 15`

reset=`tput sgr0`

# Faveo Banner.

echo -e "$skyblue                                                                                                                    $reset"
sleep 0.05
echo -e "$skyblue                                   _______ _______ _     _ _______ _______                                          $reset"
sleep 0.05
echo -e "$skyblue                                  (_______|_______|_)   (_|_______|_______)                                         $reset"
sleep 0.05
echo -e "$skyblue                                   _____   _______ _     _ _____   _     _                                          $reset"
sleep 0.05
echo -e "$skyblue                                  |  ___) |  ___  | |   | |  ___) | |   | |                                         $reset"
sleep 0.05
echo -e "$skyblue                                  | |     | |   | |\ \ / /| |_____| |___| |                                         $reset"
sleep 0.05
echo -e "$skyblue                                  |_|     |_|   |_| \___/ |_______)\_____/                                          $reset"
sleep 0.05
echo -e "$skyblue                                                                                                                    $reset"
sleep 0.05
echo -e "$skyblue                          _     _ _______ _       ______ ______  _______  ______ _     _                            $reset"
sleep 0.05
echo -e "$skyblue                        (_)   (_|_______|_)     (_____ (______)(_______)/ _____|_)   | |                            $reset"
sleep 0.05
echo -e "$skyblue                         _______ _____   _       _____) )     _ _____  ( (____  _____| |                            $reset"
sleep 0.05
echo -e "$skyblue                        |  ___  |  ___) | |     |  ____/ |   | |  ___)  \____ \|  _   _)                            $reset"
sleep 0.05
echo -e "$skyblue                        | |   | | |_____| |_____| |    | |__/ /| |_____ _____) ) |  \ \                             $reset"
sleep 0.05
echo -e "$skyblue                        |_|   |_|_______)_______)_|    |_____/ |_______|______/|_|   \_)                            $reset"
sleep 0.05
echo -e "$skyblue                                                                                                                    $reset"
sleep 0.05
echo -e "$skyblue                                                                                                                    $reset"
                                                                                        

if [[ $# -lt 8 ]]; then
    echo "Please run the script by passing all the required arguments."
    exit 1;
fi

echo "Checking Prerequisites....."
setenforce 0
apt update; apt install unzip curl -y || yum install unzip curl -y

DockerVersion=$(docker --version)

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "Docker is not found in this server, Please install Docker and try again."
echo -e "\n";
exit 1;
else 
echo -e "\n";
echo $DockerVersion
echo -e "\n";
fi

DockerComposeVersion=$(docker-compose --version)

if [[ $? != 0 ]]; then
echo -e "\n";
echo -e "Docker Compose is not found in this server please install Docker Compose and try again."
echo -e "\n";
exit 1;
else 
echo -e "\n";
echo $DockerComposeVersion
echo -e "\n";
fi

if [[ $? -eq 0 ]]; then

    echo  -e "\n";
    echo "Prerequisites check completed."
    echo -e "\n";
else
    echo -e "\n";
    echo "Check failed please make sure to execute the script as sudo user and also check your Internet connectivity."
    echo  -e "\n";
    exit 1;
fi
CUR_DIR=$(pwd)
host_root_dir="faveo"
# Evaluate the arguments
while test $# -gt 0; do
        case "$1" in
                -domainname)
                    shift
                    domainname=$1
                    shift
                    ;;
                -email)
                    shift
                    email=$1
                    shift
                    ;;
                -license)
                    shift
                    license=$1
                    shift
                    ;;
                -orderno)
                    shift
                    orderno=$1
                    shift
                    ;;
                *)
                echo "$1 is not a recognized flag!"
                exit 1;
                ;;
        esac
done
echo -e "\n";
echo -e "Confirm the Entered Helpdesk details:\n";
echo -e "-------------------------------------\n"

echo "Domain Name : $domainname";
echo "Email: $email";
echo "License Code: $license";
echo "Order Number: $orderno";
echo -e "\n";
read -p "Continue (y/n)?" REPLY

if [[ ! $REPLY =~ ^(yes|y|Yes|YES|Y) ]]; then
        exit 1;
fi;

if [ ! -d $CUR_DIR/certbot/html ]; then
    mkdir -p $CUR_DIR/certbot/html
elif [ ! -e $CUR_DIR/certbot/html ]; then
    exit 0;
fi;

echo "<h1>Obtain SSL Certs</h1>" > $CUR_DIR/certbot/html/index.html

echo -e "Initializing Temporary Apache container to obtain SSL Certificates..."

docker run -dti -p 80:80 -v $CUR_DIR/certbot/html:/usr/local/apache2/htdocs --name apache-cert httpd:2.4.33-alpine

if [[ $? -eq 0 ]]; then
    echo "Initializing Certbot Container to obtain SSL Certificates for $domainname"
    docker run -ti --rm -v $CUR_DIR/certbot/letsencrypt/etc/letsencrypt:/etc/letsencrypt -v $CUR_DIR/certbot/html:/data/letsencrypt --name certbot certbot/certbot certonly --webroot --email $email  --agree-tos --non-interactive  --no-eff-email --webroot-path=/data/letsencrypt -d $domainname
else
    echo "Temporary Container Failed to Initialise exiting..."
    exit 1;
fi;

docker rm -f apache-cert

crontab -l | { cat; echo "45 2 * * 6 docker run -ti --rm -v $CUR_DIR/certbot/letsencrypt/etc/letsencrypt:/etc/letsencrypt -v $CUR_DIR/certbot/html:/data/letsencrypt --name certbot certbot/certbot certonly --webroot --email $email   --agree-tos --non-interactive  --no-eff-email --webroot-path=/data/letsencrypt -d $domainname >/dev/null 2>&1"; } | crontab -

chown -R $USER:$USER $CUR_DIR/certbot

if [[ $? -eq 0 ]]; then
    echo "SSL Certificates for $domainname obtained Successfully."
else
    echo "Permission Issue."
    exit 1;
fi;

echo -e "\n";
echo "Downloading Faveo Helpdesk"

curl https://billing.faveohelpdesk.com/download/faveo\?order_number\=$orderno\&serial_key\=$license --output faveo.zip


if [[ $? -eq 0 ]]; then
    echo "Download Successfull";
else
    echo "Download Failed. Please check the order number, serial number of Helpdesk entered and your Internet connectivity."
    exit 1;
fi;

echo -e "\n";
echo "Extracting please wait ..."
echo -e "\n";
if [ ! -d $CUR_DIR/$host_root_dir ]; then
    unzip -q faveo.zip -d $host_root_dir
else
    rm -rf $CUR_DIR/$host_root_dir
    unzip -q faveo.zip -d $host_root_dir
fi

if [ $? -eq 0 ]; then
    chown -R 33:33 $host_root_dir
    find $host_root_dir -type d -exec chmod 755 {} \;
    find $host_root_dir -type f -exec chmod 644 {} \;
    echo "Extracted"
else
    echo "Extract failure."
fi

db_root_pw=$(openssl rand -base64 12)
db_name=faveo
db_user=faveo
db_user_pw=$(openssl rand -base64 12)


if [[ $? -eq 0 ]]; then
    rm -f .env
    cp example.env .env
    sed -i 's:MYSQL_ROOT_PASSWORD=:&'$db_root_pw':' .env
    sed -i 's/MYSQL_DATABASE=/&'$db_name'/' .env
    sed -i 's/MYSQL_USER=/&'$db_user'/' .env
    sed -i 's:MYSQL_PASSWORD=:&'$db_user_pw':' .env
    sed -i 's/DOMAINNAME=/&'$domainname'/' .env
    sed -i '/ServerName/c\    ServerName '$domainname'' ./apache/000-default.conf
    sed -i 's:domainrewrite:'$domainname':g' ./apache/000-default.conf
    sed -i 's/HOST_ROOT_DIR=/&'$host_root_dir'/' .env
    sed -i 's:CUR_DIR=:&'$PWD':' .env
else
    echo "Database Password Generation Failed"
fi


if [[ $? -eq 0 ]]; then
    docker volume create --name ${domainname}-faveoDB
fi

docker network rm ${domainname}-faveo

docker network create ${domainname}-faveo --driver=bridge --subnet=172.24.2.0/16

if [[ $? -eq 0 ]]; then
    echo " Faveo Docker Network ${domainname}-faveo Created"
else
    echo " Faveo Docker Network Creation failed"
    exit 1;
fi

if [[ $? -eq 0 ]]; then
    docker-compose up -d
fi

if [[ $? -eq 0 ]]; then
    echo -e "\n"
    echo "#########################################################################"
    echo -e "\n"
    echo "Faveo Docker installed successfully. Visit https://$domainname from your browser."
    echo "Please save the following credentials."
    echo "Database Hostname: faveo-mariadb"
    echo "Mysql Database root password: $db_root_pw"
    echo "Faveo Helpdesk name: $db_name"
    echo "Faveo Helpdesk DB User: $db_user"
    echo "Faveo Helpdesk DB Password: $db_user_pw"
    echo -e "\n"
    echo "#########################################################################"
else
    echo "Script Failed unknown error."
    exit 1;
fi

