### :camel: command based tasks
---
* __*this workshop needs ncodeit custom ubuntu server*__

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

#### Task3: list all images available on the local server
```
docker  image ls -a         # list all the images on local server

```
#### Task4: delete images
```
docker  image ls -a         # to list images
docker  rmi  httpd          # remove httpd image from local server
```
#### Task5: launch containers with port and volumes
* containers can be launched with available images or images that are not currently available on local system. Incase , the image is not available locally docker will try to pull it from repository
```
# launch apache httpd container with 80 port from container mapped to 8888 port on host
# also , the htdocs directory where deployment files should be copied is mapped to /root/my-httpd-files directory on host
docker  run -d -p 8888:80 -v /root/my-httpd-files:/usr/local/apache2/htdocs --name ncd-apache1 httpd

netstat -nap|grep 8888      # check for port 8888 on host. Remember https is running on 80 inside container

# launch tomcat container with 8080 port from container mapped to 7777 port onn host
# webapps directory of tomcat is mapped to /root/my-tomcat-webapps on host
docker  run -d -p 7777:8080 -v /root/my-tomcat-webapps:/usr/local/tomcat/webapps --name ncd-tomcat1 tomcat      

netstat -nap|grep 7777      # check for port 7777 on host. Remember its running on 8080 inside container


docker logs ncd-tomcat1  --follow       # check the logs of container ncd-tomcat1 . Follow the logs. Press ctrl+c to exit

docker inspect ncd-tomcat1      # inspect the meta data of containers. eg: ports , volumes etc
```
* deploy a sample application to both apps by copying the file to host mapped directory
```
cp /tmp/apache.html   /root/my-httpd-files          # copy apache.html for apache server
cp /tmp/ncodeit.war   /root/my-tomcat-webapps       # copy ncodeit.war file for tomcat server

docker logs ncd-tomcat1  --follow                   # check if ncodeit.war file is deployed
```
* once launched , apache and tomcat servers can be accessed on host's exposed ports

```
curl -I <ip-of-vm>:8888/apache.html     # httpd server is accessible on 8888 port of host server
curl -I <ip-of-vm>:7777/ncodeit/ncodeit.html     # tomcat server is accessible on 7777 port of host server
```
* you can use any port available on host to map to any port inside the container

#### Task6: login to containers & execute commands inside containers
```
docker exec -it ncd-tomcat1 /bin/bash       # start a bash shell inside a container
docker exec -it ncd-tomcat1 hostname        # run hostname command inside a container
docker exec -it ncd-tomcat1 top             # run top command inside a contaienr. press q to exit
```

#### Task7: stop/start/restart/kill  containers
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

#### Task8: commit & save existing containers
* sometimes we want to save an existing container as image. To take the image to another system
* _this is not recommended practice. images should not be created from containers. Instead use `Dockerfile` to create images
```
docker pull ubuntu                                   # pull ubuntu image. Yes, ubuntu also can be run inside a container
docker run -it ubuntu /bin/bash                      # login to ubuntu image
    apt-get update -y && apt-get install htop -y     # inside the container. install htop
    htop                                             # run htop command inside the container . press q to exit out of htop
    exit
docker ps -a                                         # check all the containers on the host

docker commit  <container-id-of-ubuntu>   ncd-ubuntu-image    #this container will be in Exited state
docker image ls -a                                   # check the images. newly created image should be available now

docker run -it ncd-ubuntu-image /bin/bash            # launch a new container from image 
    htop                                             # this command is availble without any installation
    exit
```
* same thing can be done for any container

#### Task9: delete containers
* remove all containers that have "exited" or "created" - 
* "created" is a state of the container when a wrong command is executed inside
```
docker ps -a            # check status of all containers
docker rm <container-id or container-name>
docker rm $(docker ps -a -f status=exited -f status=created -q)     # remove all containers in exited or created state
```

#### Task10: creat dockerhub account 
* go to www.docker.com and create a free account for yourself
* login to the account -> click "Create Repository" -> create a new repository
* you will push some images into this repository of your account in the next steps

#### Task11: tag images & push images to dockerhub
* tagging in simple words is to give a version to an existing image
* syntax `docker tag <existing-image-with-tag>  <dockerhub-user>/<remote-image-name-with-tag>`
* __repository name on dockerhub.com should be same as the image name thats being tagged__
* once the tagging is done, login to docker registry with `docker login`
* then push the image to docker registry using `docker push`
* lets tag our image and push to the newly created dockerhub account 
```
docker pull tomcat:8.5                    # pull tomcat 8.5 image from dockerhub official apache repo

docker image list -a                      # list all the images available locally

docker tag tomcat:8.5   <dockerhub-username>/tomcat:8.5.ncd    # tag can be anything. ncodeitdocker is the username on dockerhub.com

docker image ls -a                          # you will see the newly created image also
# now login to dockerhub.com and create a repository with name "tomcat" . Other repo names will not work
# name of the image and name of repo should be same

docker login         # provide your dockerhub username/password 

docker push <dockerhub-username>/tomcat:8.5.ncd      # pushes image to repo in your account

# login to dockerhub and make sure the new image is avaialble there

docker logout       #logout of dockerhub account

rm  /root/.docker/config.json       # remove the stored credentials 
```

#### Task12: Link multiple containers with one another

* for eg: if a database is required for application, a database container is launched first and then other container is launched. 
![wordpress and mysql architecture](https://miro.medium.com/max/841/1*OkW9CNab5pe8q5HZLz6cDw.png)
* Lets deploy mysql/mariadb first and link this container to frontend wordpress container 

```
mkdir /root/wordpress && cd /root/wordpress     #create two directories to map to containers

# launch the backend mysql(mariadb) container, setup parameters using -e
# and mount /root/wordpress/database directory from host to /var/lib/mysql on the container
docker run -e MYSQL_ROOT_PASSWORD=ncodeit123 -e MYSQL_DATABASE=wordpress --name wordpressdb -v "/root/wordpress/database":/var/lib/mysql -d mariadb:latest

docker ps -a    # check the list of containers

# launch the frontend wordpress container . Link it to backend mysql using "--link" keyword
# so frontend container is linked to backend container 

docker run -e WORDPRESS_DB_PASSWORD=ncodeit123 --name wordpress10 --link wordpressdb:mysql -p 8089:80 -v "/root/wordpress/html":/var/www/html -d wordpress

docker ps -a 
```

* now check that the wordpress is accessible. Launch `Display UI` , access port 80

#### Task13: Install docker-compose and launch linked containers using yaml files
* make sure docker-ce is already installed. If not, install it first
* first install docker-compose 
```
# install docker-compose 

curl -L https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

docker-compose --version        # check version of docker-compose
```
* create a separate directory `wordpress-compose` and setup `docker-compose.yml` file
* file name should be `docker-compose.yml` only

```
mkdir /root/wordpress-compose && cd /root/wordpress-compose

cp /tmp/docker-compose-wordpress.yml /root/wordpress-compose/docker-compose.yml #copy docker-compose.yml 

cat docker-compose.yml          #take a quick look at the file

docker-compose up -d                                 #build the services for first time 

docker-compose ps           # list all containers running under this docker-compose
docker-compose top          # list all processes running inside the containers
```
* access the wordpress site on port 80 and make sure its accessible
* now lets perform some operations on these containers
```
docker-compose logs                 # show the logs of all containers

docker-compose stop         # stop all containers
docker-compose ps           # check status of containers

docker-compose start        # start all containers
docker-compose ps           # check status of containers

docker-compose kill         # kill if stop is not working
docker-compose ps           # check status of containers

```

#### Task14: setup private docker registry
* instead of pulling images from dockerhub, we can setup our own private docker registry
```
mkdir /root/docker-registry     # create a separate directory for docker-registry
cd /root/docker-registry 
cp /tmp/docker-compose-registry.yml ./docker-compose.yml
cat docker-compose.yml          # take a quick look at the docker-compose.yml file

docker-compose up -d            # bring up the registry container
docker-compose ps               # check the status 
docker-compose logs             # check logs

netstat -nap |grep 5000         # check port 5000 is listening 
curl -X GET http://<ip-of-your-vm>:5000/v2/_catalog     # list the images in the repo. Now its empty

```
* If you want access the catalog from browser 
    + click __Dashboard for UI__ , give port 5000, let the page open 
    + add `/v2/_catalog` to the end of the url to see the list of images on the private registry

#### Task15: tag and push images to private docker registry
* now that the registry is up, lets push some images to registry
* pull some images from dockerhub , tag them with new version, push them to private registry
```
docker pull busybox     # busybox is a popular image with lot of linux tools
docker pull httpd:2.4   # pull apache httpd server 
docker pull jenkins/jenkins:lts     # pull jenkins image 
docker pull alpine/git              # git software installed on alpine os 

docker image ls -a          # list all images on the host

# now tag all images with "ncdv1" 

docker image tag busybox:latest localhost:5000/busybox:ncdv1    #tag busybox:latest to push to local 
docker image tag httpd:2.4 localhost:5000/httpd:ncdv1
docker image tag jenkins/jenkins:lts localhost:5000/jenkins:ncdv1
docker image tag alpine/git:latest localhost:5000/git:ncdv1

docker image ls -a          # list all images on the host

# push all the newly tagged images to private registry and then remove those tagged images from host
docker push localhost:5000/busybox:ncdv1     #image pushed to private registry
docker push localhost:5000/httpd:ncdv1
docker push localhost:5000/jenkins:ncdv1
docker push localhost:5000/git:ncdv1

# now you have all the images on the private registy
# Lets cleanup these images from host

docker rmi busybox:latest   # remove busybox:latest from current host
docker rmi localhost:5000/busybox:ncdv1   # remove busybox:ncdv1 from current host

docker rmi httpd:2.4
docker rmi localhost:5000/httpd:ncdv1

docker rmi jenkins/jenkins:lts
docker rmi localhost:5000/jenkins:ncdv1

docker rmi alpine/git:latest
docker rmi localhost:5000/git:ncdv1

# Lets check if the images are in our private registry or not. We have only removed them from host
curl -X GET http://<ip-of-your-vm>:5000/v2/_catalog



#we have created this image to push to private registry. Now we will delete from host and then pull from private registy 

docker image ls -a          # list all images on the host. You should not see the removed images.

# list repositories in the private registry 
curl -X GET http://<ip-of-your-vm>:5000/v2/_catalog

# with in each repository , there will be images with different tags. Lets list out tags for httpd image
# curl -X GET http://<ip-of-your-vm>:5000/v2/<name>/tags/list
curl -X GET http://<ip-of-your-vm>:5000/v2/httpd/tags/list  # list all tags for httpd image

# now lets pull the same image from private registry instead of dockerhub

docker pull localhost:5000/busybox:ncdv1
docker pull localhost:5000/httpd:ncdv1
docker pull localhost:5000/jenkins:ncdv1
docker pull localhost:5000/git:ncdv1

# now all the images are pulled to current host from private registry
# list list all the images

docker image ls -a          # list all images on host. YOu should see the newly pulled image from private registry 

```
#### Task16: Build a docker image with Docker
![Dockerfile used to build "docker imag" which is used to launch "docker conntainer](https://miro.medium.com/max/3600/0*CP98BIIBgMG2K3u5.png)
* Lets build a httpd docker image based on an existing Dockerfile
* syntax of building docker images is `docker build -t <tag-name> .`  - observe the `. dot`
```
mkdir $HOME/my-custom-httpd-image && cd $HOME/my-custom-httpd-image
curl -OL https://raw.githubusercontent.com/ncodeit-io/devops-cloud/main/docker/Dockerfile        #download the Dockerfile
curl -OL https://raw.githubusercontent.com/ncodeit-io/devops-cloud/main/docker/index.html         #copy a simple index.html file

docker build -t myhttpdimage:ncdv1 .      # build the image with tag myhttpdimage. This image can be pushed to dockerhub.

# if you need to push the image to another regisistry tag it again and push to private registry

docker image ls -a      # check if the newly created image exists or not 

docker run -itd --name ncd-myhttpdimage-container -p 5050:80 myhttpdimage:ncdv1     # launch a container with newly created image
docker ps -a            # check if the launched container is 

curl localhost:5050     # the index.html page we have pushed into image should be visible. 5050 is port we mapped from host to 80 on container

```
---
---
