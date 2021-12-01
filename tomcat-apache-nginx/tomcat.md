### :camel: command based tasks
---
#### Task1: Install tomcat 
```
sudo apt update -y

sudo apt install default-jdk -y     #install java . This is pre-requisite for tomcat

java --version      # check java version

sudo update-java-alternatives -l    # this will give java path. Currently /usr/lib/jvm/java-1.11.0-openjdk-amd64

wget https://mirrors.estointernet.in/apache/tomcat/tomcat-9/v9.0.41/bin/apache-tomcat-9.0.41.tar.gz -P /tmp  #download tomcat installation file

sudo tar zxvf /tmp/apache-tomcat-9*.tar.gz -C /opt/   # extract the code under /opt/
mv /opt/apache-tomcat-9* /opt/tomcat                  # rename the extracted apache-tomcat-9-x-x directory to tomcat


```


#### Task2: setup tomcat as a service
```
cd /etc/systemd/system

sudo touch tomcat.service

sudo nano tomcat.service    # copy the code between the lines into tomcat.service file
===============================================
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=oneshot

Environment=JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64        #make sure this is correct
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=root
Group=root
UMask=0007
RestartSec=10
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
========================================================
# after updating the tomcat.service file with above content save and close with ctrl+o , Enter, ctrl+x 

# make sure the java path is updated properly
sudo systemctl daemon-reload        #reload the processe

sudo systemctl enable tomcat        #enable tomcat server to start the system start

```

#### Task3: start/stop/restart tomcat
```
sudo systemctl status tomcat    # check status

sudo systemctl start tomcat      # start tomcat server    
sudo systemctl status tomcat     # check status tomcat server

sudo systemctl stop tomcat; sudo systemctl status tomcat        # stop and check status

sudo systemctl restart tomcat  ; sudo systemctl status tomcat   # restart and check status
```
### Task4: Allow access to tomcat webgui from outside
```
#tomcat web gui accessible only from localhost. Allow external access

sudo cp /root/context.xml /opt/tomcat85/webapps/host-manager/META-INF/context.xml

sudo cp /root/context.xml  /opt/tomcat85/webapps/manager/META-INF/context.xml
```
#### Task5: check the default page of tomcat from command prompt
* tomcat default port is 8080
```
curl http://<ip-of-server>:8080     # will show default page

curl -I http://<ip-of-server>:8080     # will show return code 200 OK
```
#### Task6: check default page of tomcat from browser

* __instructions applicable if working on katacoda Ubuntu server__
* click on __Dashboard for UI__ tab on the katacoda browser
* on the newly opened webpage , give __8080__ as __Display Port__
* you will be able to see the default page of tomcat server
* change the url to required one to access different pages on tomcat

#### Task7: check the configuration file and change the port
```
cd /opt/tomcat/conf     #tomcat configuration directory

sudo nano  server.xml   #tomcat configuration file 
#check for line `<Connector port="8080" protocol="HTTP/1.1" ` and change 8080 to 7070
#save and close by ctrl+o , Enter , ctrl+x

sudo grep 7070 server.xml   # grep for line containing 7070 in server.xml 

sudo systemctl restart tomcat     # restart tomcat server

sudo systemctl status tomcat      # check tomcat server status make sure its running

curl http://<ip-of-server>:7070   # try to access on port 7070
```
#### Task8: check the log files of tomcat
```
cd /opt/tomcat      #tomcat root diretory

cd logs             #tomcat logs directory 

ls -ltr             # list all files in logs directory with latest file at bottom

cat catalina.out    # this is main tomcat file
```
#### Task9: deploy application to tomcat 
* any java archive (war/ear) deployed to /opt/tomcat/webapps directory will be automatically deployed to tomcat server
* open __TWO__ terminals to the same server. terminal1 for monitoring logs and terminal2 to DEPLOY the app

```
# on terminal 1
cd /opt/tomcat/logs     # go to tomcat logs directory
tail -f catalina.log    # tail the log file for fresh deployment. press ctrl+c to exit out of log


# on terminal 2
sudo cp /root/SampleWebApp.war /opt/tomcat/webapps    #copy 

# now go back to terminal1 and see the log. Newly deployed helloworld.jar will be deployed
```
* access the webpage http://<ip-of-server>:7070/helloworld

#### Task10: undeploy application from tomcat
* remove the jar archive (war/ear) to undeploy the application. Only the jar/war/ear, not the directory
* open __TWO__ terminals to the same server. terminal1 for monitoring logs and terminal2 to UNDEPLOY the app
```
# on terminal 1

cd /opt/tomcat/logs     # go to tomcat logs directory

tail -f catalina.log    # tail the log file for fresh deployment. press ctrl+c to exit out of log

# on terminal 2
cd /opt/tomcat/webapps

rm -rf SampleWebApp.war   # do not touch SampleWebApp directory. After the jar is removed , the directory will automatically gets removed

# now go back to terminal1 and see the log. You will see that the SampleWebApp application is getting undeployed

```
* access the webpage http://<ip-of-server>:7070/SampleWebApp  # it will not be accessible

----
----

### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 
