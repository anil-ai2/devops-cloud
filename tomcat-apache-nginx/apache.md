### :camel: command based tasks
---
#### Task1: Install apache server
```
apt update -y   # update the repositories

apt install apache2 -y 

```
#### Task2: stop/start/restart apache server
```
sudo systemctl status apache2   # check status of apache server
sudo systemctl enable apache2   # enable auto start when system starts
sudo systemctl start apache2    # start apache server
sudo systemctl stop apache2     # stop apache server
sudo systemctl restart apache2  # restart apache server
```

#### Task3: access the default page
* apache runs on port `80`
```
curl  http://<ip-of-the-server> #default page of apache 
curl -I http://<ip-of-the-server> #200 OK successful access code
```

#### Task4: check the configuration file and change port to 8080
```
cd /etc/apache2               #apache configuration default directory
sudo nano ports.conf        #config file of httpd (apache) server
# search for "Listen 80"
# chage to "Listen 8080"    
# save and close the file   ctrl+o , Enter , ctrl+x
sudo systemctl restart apache2           #restart apache httpd server
sudo systemctl status apache2            # check status
curl  http://<ip-of-the-server>:8080     #server accessible on 8080
curl -I http://<ip-of-the-server>:8080   #200 OK successful access code
```
#### Task5: deploy html file to apache server
* any html/css file copied to `/var/www/html` directory is automatically server by apache server.
```
cd /var/www/html    # application directory for apache httpd server
echo "<h1>Hello from server $(hostname -f) </h1>" >> new-file.html     # new content added to index.html file 
sudo systemctl restart apache2      # apache server needs a restart to pick new files
curl  http://<ip-of-the-server>:8080/new-file.html     #server accessible on 8080
curl -I http://<ip-of-the-server>:8080/new-file.html   #200 OK successful access code
```
#### Task6: undeploy html file from apache server
* if the html file is removed from `/var/www/html` directory then its undeployed. Restart of apche2 is required
```
cd /var/www/html
rm new-file.html
sudo systemctl restart apache2      # apache server needs a restart if fles change
curl  http://<ip-of-the-server>:8080/new-file.html     #page NOT accessible anymore
curl -I http://<ip-of-the-server>:8080/new-file.html   #404, Page not found error
```
#### Task7: check logs for errors
* apache and nginx has similar log files. `access.log` and `error.log`
```
cd /var/log/apache2
cat access.log      # check the access.log
cat error.log       # check error log to troubleshoot errors
```
---
---
### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 