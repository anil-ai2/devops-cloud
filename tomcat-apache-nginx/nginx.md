### :camel: command based tasks
---
#### Task1: Install nginx 
```
sudo apt update -y 
sudo apt install nginx -y 
```
#### Task2: check status , stop/start/restart 
```
sudo systemctl enable nginx # automatically start nginx with system start
systemctl status nginx

systemctl stop nginx
systemctl status nginx

systemctl start nginx
systemctl status nginx

systemctl restart nginx
systemctl status nginx
```
#### Task3: access the default nginx page 
```
curl http://<ip-of-your-server>:80  #check if the server is accessble from command prompt
curl -I http://<ip-of-your-server>:80  # 200 OK. Successful page access
```
* __instructions applicable if working on katacoda Ubuntu server__
* click on __Dashboard for UI__ tab on the katacoda browser
* on the newly opened webpage , give __80__ as __Display Port__
* you will be able to see the default page of nginx server
#### Task4: deploy a new html file to nginx 
```
cd /var/www/html    #this is the default directory for deploying the applications
echo "<h1>Hello from server $(hostname -f) </h1>" >> new-file.html  # create a new html file with hostname in it

sudo cat  new-file.html  # check the content is correct
sudo systemctl restart nginx
sudo systemctl status nginx

curl http://<ip-of-your-servr>:80/new-file.html  #display the newly deployed file
curl -I http://<ip-of-your-servr>:80/new-file.html  #returns 200 OK if the newly deployed file is accessible
curl -I http://<ip-of-your-servr>/new-file.html  #port 80 is default. That means if we dont specify port, then 80 is assumed
```
#### Task5: open the configuration file and change the port of nginx
```
cd /etc/nginx/sites-enabled      #nginx default page location
sudo nano default    #nginx configuration file 
#look for port "listen 80 default_server;"  & "listen [::]:80 default_server; "and change to "listen 8080 default_server;" ,"listen [::]:8090 default_server;"
ctrl+o , Enter , ctrl+x # save and exit nano 
cat default         # make sure 80 is changed to 8080

sudo systemctl stop nginx       #stop the nginx  server
sudo systemctl status nginx     #check the status
sudo systemctl start nginx      #start the nginx server
sudo systemctl status nginx     #check the status and make sure its active 

curl http://<ip-of-your-servr>:8080/new-file.html #earlier url is now accessible on 8080. It will not be accessible on 80
curl http://<ip-of-your-servr>:80/new-file.html # this will give error, because we chagned the port to 8080

curl -I http://<ip-of-your-servr>:8080/new-file.html # 200 OK successful return code
curl -I http://<ip-of-your-servr>:80/new-file.html # 404 , Unsuccessful return code 

```
* __instructions applicable if working on katacoda Ubuntu server__
* click on __Dashboard for UI__ tab on the katacoda browser
* on the newly opened webpage , give __8080__ as __Display Port__
* you will be able to see the default page of nginx server
* to the end of url , add `/new-file.html` and you will be able to see the new-file.html on the 8080 port

#### Task6: Check the log file of nginx for troubleshooting
```
cd /var/log/nginx   # nginx log location
ls -ltr             # check the list of log files 
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
