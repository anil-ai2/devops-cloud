### :camel: command based tasks
---
#### Task1: Install nginx 
```
sudo apt update
sudo apt install nginx
```
#### Task2: check status , stop/start/restart 
```
sudo systemctl enable nginx # automatically start nginx with system start
systemctl status nginx
systemctl stop nginx
systemctl start nginx
systemctl restart nginx
```
#### Task3: access the default nginx page 
```
curl http://<ip-of-your-server>:80  #This should be used if your linux box is behind a jump server
curl -I http://<ip-of-your-server>:80  # if the return code is 200 then the curl is working
```
#### Task4: deploy a new html file to nginx 
```
cd /var/www/html    #this is the default directory for deploying the applications
sudo nano new-file.html
#enter your name 
ctrl+o , Enter , ctrl + x # to save and exit the nano editor

sudo cat  new-file.html  # check the content is correct
sudo systemctl restart nginx
curl http://<ip-of-your-servr>:80/new-file.html  #display the newly deployed file
curl -I http://<ip-of-your-servr>:80/new-file.html  #returns 200 OK if the newly deployed file is accessible
curl -I http://<ip-of-your-servr>/new-file.html  #port 80 is default. That means if we dont specify port, then 80 is assumed
```
#### Task5: open the configuration file and change the port of nginx
```
cd nano /etc/nginx      #nginx configuration directory
sudo nano nginx.conf    #nginx configuration file 
#look for port 80 and change to 8080
ctrl+o , Enter , ctrl+x # save and exit nano
sudo systemctl stop nginx       #stop the nginx  server
sudo systemctl start nginx      #start the nginx server
sudo systemctl status nginx     #check the status and make sure its active 

curl http://<ip-of-your-servr>:8080/new-file.html #earlier url is now accessible on 8080. It will not be accessible on 80
curl http://<ip-of-your-servr>:80/new-file.html # this will give error, because we chagned the port to 8080

curl -I http://<ip-of-your-servr>:8080/new-file.html # 200 OK successful return code
curl -I http://<ip-of-your-servr>:80/new-file.html # 404 , Unsuccessful return code 

```
#### Task6: Check the log file of nginx for troubleshooting
```
cd /var/log/nginx   # nginx log location
cat access.log      # show all the log entries that are accessing nginx server . you will see 200 ok messages
cat error.log       # errors related to nginx 
```
---
---
### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 