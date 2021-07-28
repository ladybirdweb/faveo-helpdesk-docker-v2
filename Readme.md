Only the following Editions of Faveo-Helpdesk are supported Freelancer, Paid and Enterprise.

Complete the below steps to get the Faveo-Helpdesk Containers up.

Provide executable permission to faveo-run.sh

```sh
chmod +x faveo-run.sh
```

Prerequisites to run the script:

1. A valid domain name fully propagated to you Server's IP.
2. Sudo Privilege.
3. Faveo license and Order number.
4. Unreserved ports 80 and 443.(If it is reserved feel free to edit and change the ports of your choice in docker-copompose.yml)
5. Operating Systems Centos 7,8 or above and Ubuntu 16,18,20.

Run the script "faveo-run.sh" with sudo privilege by passing the necessary arguments.

Note: You should have a Valid domain name pointing to your public IP. Since this domainname is used to obtain SSL Certificates from Let's Encrypt CA and the Email is used for the same process.The license code and Order Number can be obtained from your Faveo Helpdesk Billing portal, make sure not to include the '#' character from Order Number. 

Usage:
```sh
	sudo ./faveo-run.sh -domainname <your domainname> -email <example@email.com> -license <faveo license code> -orderno <faveo order number>
```
Example: It should look something like this.
```sh
      sudo ./faveo-run.sh -domainname berserker.tk -email berserkertest@gmail.com -license 5H876HHDGDIBK0000 -orderno 81230569
```
After the docker installation completed you will be prompted with Database Credentials please copy and save them somewhere safe.

Visit https://<yourdomainname> complete the readiness probe, input the Database Details when prompted and complete the installation.

There is one final step needs to be done in order complete the installation. You have to edit the .env file which is generated in the Faveo root directory after completing the installation in browser. Open terminal and navigate to the faveo-docker directory here you will find the directory "faveo" which is downloaded while running the script this directory contains all the Helpdesk codebase, inside it you need to edit the ".env" file and update the "Redis Host" value to "redis" by default it will be pointing to loopback address "127.0.0.1" here redis is the DNS name of redis container which will be resolved by the docker daemon.
	
Configure Cronjob for Auto Renwal of SSL Certificates:
- Replace the path, email and domain name accoringly that suits yours.
```sh
	45 2 * * 6 docker run -ti --rm -v /root/faveo-helpdesk-docker-v2/certbot/letsencrypt/etc/letsencrypt:/etc/letsencrypt -v /root/faveo-helpdesk-docker-v2/certbot/html:/data/letsencrypt --name certbot certbot/certbot certonly --webroot --email berserker@gmail.com  --agree-tos --non-interactive  --no-eff-email --webroot-path=/data/letsencrypt -d berserker.tk
```

