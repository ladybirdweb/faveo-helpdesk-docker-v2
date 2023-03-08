## Faveo Helpdesk Docker

A pretty simplified Docker Compose workflow set up a network of containers for the Faveo Helpdesk.
All the Faveo Helpdesk editions are supported.

## Usage
___

Before getting started, make sure you have Docker and docker-compose installed on your system, and then clone this repository.


```sh
git clone https://github.com/ladybirdweb/faveo-helpdesk-docker-v2.git
```
---
### For all Faveo Edition (excpet community edition):
Next, navigate to your terminal to the directory you cloned this, and give the executable permission to faveo-run.sh bash script.


```sh
chmod +x faveo-run.sh
```

### For Faveo Community Edition:
Next, navigate to your terminal to the directory you cloned this, and give the executable permission to faveo-community-run.sh bash script.

```sh
chmod +x faveo-community-run.sh
```
---
## Prerequisites to run the script:

A valid domain name wholly propagated to your Server's IP.
Sudo Privilege.
Faveo license and Order number.
Unreserved ports 80 and 443. (If it is reserved, feel free to edit and change the ports of your choice in docker-copompose.yml)
Operating Systems Centos 7,8 or above, and Ubuntu 16,18,20.

## To get the Containers up and running, follow the instructions below.
---
### Run the script "faveo-run.sh" by passing the necessary arguments for Faveo Editions except Faveo Community Edition.

Note- You should have a Valid domain name pointing to your public IP. This domain name is used to obtain SSL certificates from Let's Encrypt CA, and the mail is used for the same purpose. The license code and Order Number can be obtained from your Faveo Helpdesk Billing portal, and make sure not to include the '#' character in the Order Number.

Usage:
```sh
 ./faveo-run.sh -domainname <your domainname> -email <example@email.com> -license <faveo license code> -orderno <faveo order number>
```
Example: It should look something like this.
```sh
 ./faveo-run.sh -domainname berserker.tk -email berserkertest@gmail.com -license 5H876********** -orderno 8123******
```
### Run the script "faveo-communtiy-run.sh" by passing the necessary arguments for Faveo Community Edition.

Note- You should have a Valid domain name pointing to your public IP. This domain name is used to obtain SSL certificates from Let's Encrypt CA, and the mail is used for the same purpose.

Usage:
```sh
 ./faveo-community-run.sh -domainname <your domainname> -email <example@email.com> 
```
Example: It should look something like this.
```sh
 ./faveo-community-run.sh -domainname berserker.tk -email berserkertest@gmail.com
```
---
After completing the Docker installation, you will be prompted with Database Credentials, which you should copy and keep somewhere secure, and a cron job to automatically renew SSL certificates from Let's encrypt. 

Visit https://yourdomainname complete the readiness probe, enter the Database information when prompted, and finish the installation.

One final step has to be done before the installation is complete. You have to edit the .env file which is generated under the Faveo root directory, after completing the installation process in the browser. Open a terminal and navigate to the faveo-docker directory. Here, you will find the directory "faveo" which is downloaded, while running the script. This directory contains all the Helpdesk codebase inside it. You need to edit the ".env" file and add REDIS_HOST=faveo-Redis. The "faveo-redis" is the DNS name of the Redis container. Finally, run the below command for changes to take effect.

```sh
	docker-compose down && docker-compose up -d
```
	



