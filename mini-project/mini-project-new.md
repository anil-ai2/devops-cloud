### :camel: setup and maintain a end-to-end CICD pipeline with github,Jenkins,Nexus,Dockerhub,Helm,K8s on AWS(EKS)
---
# pipeline1 - Legacy Application - no containers 
### Architecture 
![Architecture of Project k8s&aws](https://i.gyazo.com/6e66f96059ab7628491ae496bc595bf6.png)  - replace this with new image

* this is only a partial architecture diagram
---
### Summary steps
![Infrastructure view of the CICD pipeline](https://i.gyazo.com/1685c88b02a384f65d56990e13ad79f8.jpg)
* Git and github for source code 
* Jenkins to run jobs that will build war file - Artifact 
* Nexus OSS to store the war file 
* Ansible to deploy the artifact to the environment of tomcat server
* QA or any other environment that has tomcat installed, where the artifact will be deployed
---

#### individual steps 
* Launch t2.micro instance for `jumpbox`
* install all required softwares (awscli)
* launch t2.micro for installing Jenkins/nexus/Ansible. Lets call it `CIServer`
* Install Jenkins/Nexus/Ansible on `CIServer`
* configure jenkins pipeline 
* Launch t2.micro for setting up the apache/tomcat environment where the application will be deployed. This is `QAServer`
* Install tomcat server on `QAServer` 
* create ansible playbook for deployment of war file to QA server
* Run the ansible playbook on `CIServer` to deploy the war file to tomcat on `QAServer`



### 	:weight_lifting: Detailed steps for pipeline1 implementation  	:weight_lifting:
* Login to root account of aws and launch an EC2 instance (t2.micro) - Download keypair to connect to ec2 instance). store this file with name `keypair-ec2-jumpbox.pem`
    + wait till the instance is launched and give it a name  `jumpbox`
    + launch mobaxterm on your laptop and connect to `jumpbox` using the keypair `keypair-ec2-jumpbox.pem`
* setup a new repository on github. Name it `ncd-realtime-project-repo`
* launch 2nd ec2 instance (t2.nano) , with below properties
    + use `ubuntu 18 imagee` thats eligibe under `free tier eligible`
    + under ingress rules add http traffic for 8080 port (to allow access to jenkins UI)
    + give the name `jenkins-server` to this ec2 instance
    + use the same keypair that was used to create first ec2 instance.  By using the same keypair we will be able to login to both instances with the same key. This will keep things simple 
    + login to `jenkins-server` ec2 instance using `keypair-admin-stance`
* clone the repo from github and install java,jenkins,maven,helm,docker using the scripts
```
cd $HOME
git clone https://github.com/ncodeit-io/devops-cloud        # clone the whole repo
cd devops-cloud/mini-project
sudo ./install_java8.sh          # install java required by jenkins
sudo ./install_jenkins.sh       # install jenkins
sudo ./install-docker-ce.sh
sudo ./install_kubectl.sh       # install kubectl
sudo usermod -aG docker,root jenkins    #and add jenkins user to docker group - 
sudo systemctl restart docker       #restart docker
sudo systemctl restart jenkins      # restart jenkins
```
    + open url `http://<public-ip-of-jenkins-server-ec2-instance>:8080`
    + finish the jenkins installation with `recommnded plugins`
    + login to `jenkins-server` ec2 instance terminal, and check maven
    + login to jenkins UI and install all the plugins as per the jenkins workshop plugins list
    + create a quick freestyle job (without nexus) and see that thre are no issues

* check versions of all the installed softwares
```
sudo docker info
```
* setup JAVA_HOME environment variable
	Dashboard -> Manage Jenkins -> configure system -> Global Properties -> Environment Varibales -> Add 
    ```
    JAVA_HOME
    /usr/lib/jvm/java-8-openjdk-amd64
    ```
---  


# pipeline2 - Legacy Application - no containers 
### Architecture 
![Architecture of Project k8s&aws](https://i.gyazo.com/6e66f96059ab7628491ae496bc595bf6.png)  - replace this with new image

* this is only a partial architecture diagram
---

### Summary steps
* Git and github for source code 
* Jenkins to run jobs that will build docker images and helm charts
* Nexus OSS to store the artifacts and helm charts (This will be replaced with S3 helm storage)
* dockerhub as a repository for docker images 
* Helm package manager to deploy helm chart based applications to EKS cluster (through jenkins pipelines)
* AWS Elastic Kubernetes Service (EKS) to host the application 
* traefik or nginx ingress controller to redirect the traffic to internal k8s services
* aws ALB (Application Load Balancer) to receive the external traffic and redirect to ingress controller

---
### 	:weight_lifting: Detailed steps  	:weight_lifting:
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
* clone the repo from github and install java,jenkins,maven,helm,docker using the scripts
```
cd $HOME
git clone https://github.com/ncodeit-io/devops-cloud        # clone the whole repo
cd devops-cloud/mini-project
sudo ./install_java8.sh          # install java required by jenkins
sudo ./install_jenkins.sh       # install jenkins
sudo ./install-docker-ce.sh
sudo ./install_kubectl.sh       # install kubectl
sudo usermod -aG docker,root jenkins    #and add jenkins user to docker group - 
sudo systemctl restart docker       #restart docker
sudo systemctl restart jenkins      # restart jenkins
```
    + open url `http://<public-ip-of-jenkins-server-ec2-instance>:8080`
    + finish the jenkins installation with `recommnded plugins`
    + login to `jenkins-server` ec2 instance terminal, and check maven
    + login to jenkins UI and install all the plugins as per the jenkins workshop plugins list
    + create a quick freestyle job (without nexus) and see that thre are no issues

* check versions of all the installed softwares
```
sudo docker info
```
* setup JAVA_HOME environment variable
	Dashboard -> Manage Jenkins -> configure system -> Global Properties -> Environment Varibales -> Add 
    ```
    JAVA_HOME
    /usr/lib/jvm/java-8-openjdk-amd64
    ```
---    
### 	:weight_lifting: Build EKS cluster 

* setup awscli, kubectl , eksctl, helm  on `admin-instance`
```
cd $HOME
git clone https://github.com/ncodeit-io/devops-cloud        # clone the whole repo
cd devops-cloud/mini-project
sudo ./install_kubectl.sh       # install kubectl
sudo ./install_eksctl.sh
sudo ./install_helm3.sh
```
* Follow the document at https://ncodeit2.atlassian.net/wiki/spaces/DEVOPSAWS/pages/20512778/Create+EKS+cluster to create EKS cluster and do the basic testing of the EKS cluster
---
### 	:weight_lifting: configure Jenkins pipeline to build docker image and push to dockerhub 
* Install the following plugins on Jenkins 
```
docker commons
docker pipeline
docker
docker-build-step
Cloudbees docker build and publish 
CloudBees Docker Custom Build Environment
kubernetes
kubernetes CLI
kubernetes continuous deploy 
Jackson 2 API - downgrade to 2.11.3
Kubernetes Credentials Provider
```
* setup the pipeline 
    + create a free dockerhub account 
    + login to your github.com account
    + go to repo `https://github.com/ncodeit-io/ncd-cicd-pipeline-to-k8s.git` and fork the repo into your own repo 
    + edit `Jenkinsfile` on github itself and change `DOCKER_IMAGE_NAME = "ncodeitdocker/train-schedule"` to `DOCKER_IMAGE_NAME = "<your-dockerhub-id>/train-schedule"`
    + commit the file with commennt "dockerhub account details updated"
* create a `credential` on jenkins to store dockerhub login details (ID must match be same as in this doc)
    + Dashboard -> Manage Jenkins -> Manage Credentials -> Jenkins -> Global Credenials -> Add credentials
```
Username: Provide your DockerHub username
Password: Provide your DuckerHub password
ID: docker_hub_login
Description: Docker Hub Login
```
* bring the `kubeconfig` file details from eks cluster to the `admin-instance`
    + login to `admin-instance`
    + switch to root `sudo su - `
    + run below command to update the local eksctl with the kubeconfig file of your cluster
    ```
    aws eks update-kubeconfig --name dev --region us-east-1     # change 'name' and 'region' as per your cluster
    ```
* run `cat $HOME/.kube/config` and make sure the cluster info is displaed. You will need this info in next step

* create a `credential` on jenkins to store `KUBECONFIG` file (ID must match be same as in this doc)
```
Click Add Credentials in the menu on the left of the page.

Add credentials with the following information:

Kind: Kubernetes configuration (kubeconfig)
ID: kubeconfig
Description: Kubeconfig
Kubeconfig: Enter directly
Content: Paste the contents of ~/.kube/config
Click OK.
```
* go to `http://jenkins0101.ncodeit.com/` and loign with your microsoft credentials that were used earlier
* create the pipeline as per `build-and-upload-docker-image-to-dockerhub`
* run the pipeline `build-and-upload-docker-image-to-dockerhub` to build and upload the image to dockerhub 

---
### 	:weight_lifting: build 2nd pipeline & Upload the docker image to dockerhub
* build another pipeline as per `build-and-upload-docker-image-to-dockerhub-microservices` on `jenkins0101.ncodeit.com` 
* run the pipeline and check if it is successful
* with this we have build 2 pipelines that can build docker images and upload them to dockerhub 
---
### 	:weight_lifting: Use helm command to deploy the helm chart to EKS cluster
* Add bitnami helm repo to helm and download a helm chart in .tgz format
* deploy a nginx webserver from this helm repo to the EKS cluster (We are not deploying the image we have built here)
```
helm repo add bitnami https://charts.bitnami.com/bitnami    # add bitnami helm repo to local helm installation
helm search repo bitnami/nginx      # search for nginx
helm install mywebserver bitnami/nginx      # install nginx webserver to EKS cluster

kubectl get svc,po,deploy -A       # get the status of services,pods,deployments on all namespaces
kubectl describe deployment mywebserver     # describe the newly deployed deployment 
kubectl get pods -l app.kubernetes.io/name=nginx    # check if all the pods for this deployment have started
kubectl get service mywebserver-nginx -o wide       # get the details of the LOADBALANCER ( EXTERNAL_IP) for this 

```
* access the nginx webserver with DNS url from `kubectl get svc -A` 

* list all the installations of helm and uninstall the deployed one 
```
helm list
helm uninstall mywebserver
```
---


### 	:weight_lifting: Delete the EKS cluster 
* login to `admin-instance`
```
# update the EKS cluster details in local `eksctl`
aws eks --region us-east-2 update-kubeconfig --name ncdk8scluster   # use the correct clustername. 
eksctl get clusters --region <region-name>      # give the region-name where the cluster is running
kubectl get svc -A
kubectl delete svc <service-name>       # first delete all services that have EXTERNAL_IP assocaited 
eksctl delete cluster --name <name-of-cluster> --region <region-of-cluster> # finally delete the cluster
```
* eksctl delete command deletes the EKS cluster cleanly and all its dependant components. It ensures that nothing is left out accidentally
---
### 	:weight_lifting: aws account cleanup using cloud-nuke command 
* install `cloud-nuke`
```
cd $HOME
git clone https://github.com/ncodeit-io/devops-cloud        # clone the whole repo
cd devops-cloud/mini-project
./install_cloud_nuke.sh
```
* run `cloud-nuke aws`
```
cloud-nuke aws --dry-run        # check the list of resources that will be removed , WITHOUT ACTUALLY DELETING
cloud_nuke aws      # delete all the  resources
```
---
### 	:weight_lifting: login to AWS console and make sure nothing is left out 
* login to EC2 dashboard and make sure nothing is avaialble in any regions 
* login to VPC dahsboard and make sure nothing is left out (Especially NAT Gateways, Elastic IPs)


## Thats all "ALL THE BEST"  :v: :wave: