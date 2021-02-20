### :camel: setup and maintain a end-to-end CICD pipeline with github,Jenkins,Nexus,Dockerhub,Helm,K8s on AWS(EKS)
---
### Architecture 
![Architecture of Project k8s&aws](https://i.gyazo.com/6e66f96059ab7628491ae496bc595bf6.png)

* *this is only a partial architecture diagram

### 
* Git and github for source code 
* Jenkins to run jobs that will build docker images and helm charts
* Nexus OSS to store the artifacts and helm charts (This will be replaced with S3 helm storage)
* dockerhub as a repository for docker images 
* Helm package manager to deploy helm chart based applications to EKS cluster (through jenkins pipelines)
* AWS Elastic Kubernetes Service (EKS) to host the application 
* traefik or nginx ingress controller to redirect the traffic to internal k8s services
* aws ALB (Application Load Balancer) to receive the external traffic and redirect to ingress controller


### 
* Login to root account of aws and launch an EC2 instance (t2.nano) - Download keypair to connect to ec2 instance). store this file with name `keypair-admin-instance`
    + wait till the instance is launched and give it a name  `admin-instance`
    + launch mobaxterm on your laptop and connect to `admin-instance` using the 
* setup a new repository on github. Name it `ncd-realtime-project-repo`
* launch 2nd ec2 instance (t2.nano) , with below properties
    + use `ubuntu 18 imagee` thats eligibe under `free tier eligible`
    + under ingress rules add http traffic for 8080 port (to allow access to jenkins UI)
    + give the name `jenkins-server` to this ec2 instance
    + use the same keypair that was used to create first ec2 instance.  By using the same keypair we will be able to login to both instances with the same key. This will keep things simple 
    + login to `jenkins-server` ec2 instance using `keypair-admin-stance`
* clone the repo from github and run `install_java8.sh` 
```
cd $HOME
git clone https://github.com/ncodeit-io/devops-cloud        # clone the whole repo
cd devops-cloud/mini-project
sudo ./install_java.sh          # install java required by jenkins
sudo ./install_jenkins.sh       # install jenkins
```
    + open url `http://<public-ip-of-jenkins-server-ec2-instance>:8080`
    + finish the jenkins installation with `recommnded plugins`
    + login to `jenkins-server` ec2 instance terminal, and check maven
```
mvn -version
```
    + install helm3 on this same instance
```
cd $HOME/devops-cloud/mini-project
sudo ./install_helm3.sh
```
    + Install docker so that jenkins can build docker images
```
cd $HOME/devops-cloud/mini-project
sudo ./install-docker-ce.sh
```
    + restart jenkins using `sudo systemctl restart jenkins`
    + login to jenkins UI and install all the plugins as per the jenkins workshop plugins list
    + create a quick freestyle job (without nexus) and see that thre are no issues

### Build and destroy EKS cluster
* Follow the document at https://ncodeit2.atlassian.net/wiki/spaces/DEVOPSAWS/pages/20512778/Create+EKS+cluster to create EKS cluster and do the basic testing of the EKS cluster
* setup awscli, kubectl , aws-iam-authenticator on `admin-instance`


### configure ingress controller (nginx or traefik)

### configure Jenkins pipeline to build docker image and helm chart



### Use helm command to deploy the helm chart to EKS cluster

###


### aws account cleanup using cloud-nuke command 
* install `cloud-nuke`
* run `cloud-nuke aws`
