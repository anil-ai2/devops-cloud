### :camel: command based tasks
---
#### Task1: Install tomcat 
```
sudo apt update 
sudo apt install default-jdk -y     #install java . This is pre-requisite for tomcat
java --version      # check java version
sudo update-java-alternatives -l    # this will give java path
wget http://www-eu.apache.org/dist/tomcat/tomcat-9/v9.0.27/bin/apache-tomcat-9.0.27.tar.gz -P /tmp  #download tomcat installation file
sudo tar zxvf /tmp/apache-tomcat-9*.tar.gz -C /opt/tomcat   # extract the code under /opt/tomcat
```


#### Task2: setup tomcat as a service
```
cd /etc/systemd/system
sudo touch tomcat.service
========================================================
sudo nano tomcat.servicee
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

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
Restart=always

[Install]
WantedBy=multi-user.target
========================================================
sudo systemctl daemon-reload        #reload the processe
sudo systemctl enable tomcat        #enable tomcat server to start the system start

```

#### Task2: start/stop/restart tomcat
```
sudo systemctl status tomcat    # check status
sudo systemctl start tomcat ;  sudo systemctl status tomcat     # start and check start
sudo systemctl stop tomcat; sudo systemctl status tomcat        # stop and check status
sudo systemctl restart tomcat  ; sudo systemctl status tomcat   # restart and check status
```
#### Task3: check the default page of tomcat
```
curl http://<ip-of-server>:8080     # will show default page
curl -I http://<ip-of-server>:8080     # will show return code 200 OK


```
#### Task4: check the configuration file and change the port
#### Task5: check the log files of tomcat
#### Task6: deploy application to tomcat 
#### Task7: undeploy application from tomcat
---
---
### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 