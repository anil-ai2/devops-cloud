### :camel: command based tasks
---
#### Task1: Install docker-ce on ubuntu18.04 
```
systemctl status docker
systemctl stop docker
systemctl start docker 

docker --version        # find docker version 
docker  info            # complete details about docker

```
#### Task2: search & Pull images from dockerhub
* docker can search and pull images from dockerhub 
```
docker search hello-world   # search for hello-world image 
docker search jenkins       # search for jenkins image in dockerhub
docker search httpd         # search for apache httpd image
docker search tomcat        # search for tomcat image

docker pull jenkins/jenkins         # pull jenkins:lts image from dockerhub
docker pull httpd           # pull httpd image
docker pull tomcat          # pull tomcat image
```
* by default docker pulls the image with `:latest` tag. This is not a good practice. Instead pull a specific version of docker image
    + go to `https://hub.docker.com/r/jenkins/jenkins/tags?page=1&ordering=last_updated` and pull the image with tag `2.263.3-lts-slim`
    `docker pull jenkins/jenkins:2.263.3-lts-slim`

#### Task4: list all images available on the local server
```
docker  image ls -a         # list all the images on local server

```
#### Task5: delete images
```
docker  image ls -a         # to list images
docker  rmi  <image-id>
```
#### Task6: launch containers with port and volumes
* containers can be launched with available images or images that are not currently available on local system. Incase , the image is not available locally docker will try to pull it from repository
```
docker  run -d -p 8888:80 -v /root/my-httpd-files:/var/www/html --name ncd-apache1 httpd      # launch apache httpd container
docker  run -d -p 7777:8080 -v /root/my-tomcat-webapps:/usr/local/tomcat/webapps --name ncd-tomcat1 tomcat      # launch tomcat container
netstat -nap|grep 7777      # check for port 7777 on host. Remember its running on 8080 inside container


docker logs ncd-tomcat1  --follow       # check the logs of container ncd-tomcat1 . Follow the logs. Press ctrl+c to exit

docker inspect ncd-tomcat1      # inspect the meta data of containers. eg: ports , volumes etc
```
* once launched , apache and tomcat servers can be accessed on host's exposed ports

```
curl -I <ip-of-vm>:8888     # httpd server is accessible on 8888 port of host server
curl -I <ip-of-vm>:7777     # tomcat server is accessible on 7777 port of host server
```
* you can use any port available on host to map to any port inside the container

#### Task7: login to containers & execute commands inside containers
```
docker exec -it ncd-tomcat1 /bin/bash       # start a bash shell inside a container
docker exec -it ncd-tomcat1 hostname        # run hostname command inside a container
docker exec -it ncd-tomcat1 top             # run top command inside a contaienr. press q to exit
```

#### Task8: stop/start/restart/kill  containers
```
docker stop ncd-tomcat1         # stop a running container
docker ps -a                    # check status of all containers
docker start ncd-tomcat1        # start a container
docker ps -a                    # check status of all containers
docker restart ncd-tomcat1      # restart a container
docker ps -a                    # check status of all containers

docker kill ncd-tomcat1         # kill the container if its not responding to stop command
docker ps -a                    # check status of all containers
```
#### Task9: commit & save existing containers
* sometimes we want to save an existing container as image. To take the image to another system
* _this is not recommended practice. images should not be created from containers. Instead use `Dockerfile` to create images
```
docker pull ubuntu              # pull ubuntu image. Yes, ubuntu also can be run inside a container
docker run -d --name ncd-ubuntu ubuntu  # launch a container using the image
docker exec -it ncd-ubuntu /bin/bash    # login to ubuntu image
    apt-get install nmap htop                    # inside the container , install nmap and htop commands
    exit
docker ps -a                    # check all the containers on the host

docker commit  ncd-ubuntu   ncd-ubuntu-image    #ncd-ubuntu container is stored as ncd-ubuntu-image image
docker images ls -a             # check the images. newly created image should be available now

docker run -d --name ncd-ubuntu-new  ncd-ubuntu-image   # launch a new container using the new image
docker exec -it ncd-ubuntu-new /bin/bash                # login to new container
    htop                                                # this command is availble without any installation


```
#### Task9: delete containers
```
* remove all containers that have "exited" or "created" - created is a state of the container when a wrong command is executed inside

docker rm $(docker ps -a -f status=exited -f status=created -q)
docker ps -a            # check status of all containers
```
#### Task10: tag images 
#### Task10: push images to dockerhub
#### Task10: Link multiple containers with one another
#### Task10: docker-compose and yaml file
#### Task3: creat dockerhub account 
#### Task10: launch a local docker repository to store images locally
#### Task10: tag and push images to local repository

---
---
### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 