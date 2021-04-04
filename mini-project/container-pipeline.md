## Pipeline2  - Containers based pipeline 
### Architecture
![Logical Flow of the pipeline](https://i.gyazo.com/8feccdb32a01e3001487bca6089f363d.png)
---
### Summary steps : 
* setup dockerhub account and a repository
* setup helm repository in s3
* setup EKS cluster
* setup jenkins pipeline to build docker image 
* setup pipeline to build helm
* deploy helm chart to kubernetes 
---
### Detailed steps : 
#### :weight_lifting:  setup dockerhub account and repository 
* create dockerhub account
* create repository with the same name as the image name that will be build later. In this lab, we are creating an image with name `train-schedule` . So, the repository name will be `train-schedule` __NOTE__: repo name should be exactly same as image name
    + If you make mistake while creating repos, then delete the repo and recrete 
* 
---
#### :weight_lifting: setup helm repository in s3
* create a bucket with a unique name, "ncd-helmrepo-<yourname>" in region `us-east-1`.
* __Note__ : region `us-east-1` is mandatory. Other regions do not work
* create a folder `stable` and inside this folder another folder `my-app`
* click on `stable/my-app` and `properties` and take the url of the s3 bucket. It will be in the format `s3://<bucket-name>/stable/myapp`
* go to jumpbox where helm3 is installed 
* configure aws with the correct credentials. And the region as `us-east-1`
```
aws configure
```
* run the following commands to install `helm-s3` plugin , initialize the s3 bucket as helm repo and add that repo to local helm
```
helm plugin install https://github.com/hypnoglow/helm-s3.git        #install helm-s3 plugin that will allow helm tool to interact with s3
#replace <bucket-name> with your bucket name for all further commands

helm s3 init s3://<bucket-name>/stable/myapp/                       # initialize the s3 bucket as helm repository
# at this step go to your s3 bucket and check if index.html file. This file will list all the charts available in the s3-helm repo
aws s3 ls s3://<bucket-name>/stable/myapp/                          # list the cotents of s3 bucket using aws cli command

helm repo add stable-myapp s3://<bucket-name>/stable/myapp/         #replace <bucket-name> with your bucket name

helm repo list                          # list all the repos that are currently added to helm tool in jumpbox.
# above command should show the newly added helm repository 
```
---
###	:weight_lifting: setup EKS cluster 

* setup awscli, kubectl , eksctl, helm  on `admin-instance`
```
cd $HOME
git clone https://github.com/ncodeit-io/devops-cloud        # clone the whole repo
cd devops-cloud/mini-project
sudo ./install_awscli2          # install awscli
sudo ./install_kubectl.sh       # install kubectl
sudo ./install_eksctl.sh        # install eksctl
sudo ./install_helm3.sh         # install helm
```
* Follow the document at https://ncodeit2.atlassian.net/wiki/spaces/DEVOPSAWS/pages/20512778/Create+EKS+cluster to create EKS cluster and do the basic testing of the EKS cluster
---
#### :weight_lifting: setup jenkins pipeline to build docker image
* install following plugins 
    + `CloudBees Docker Build and Publish plugin`
    + `Docker Commons Plugin`
    + `Docker plugin`
    + `docker-build-step`
    + `Kubernetes CLI Plugin`
    + `Kubernetes Continuous Deploy Plugin`
    + `Kubernetes plugin`

* Login to your github account, then, open the url https://github.com/ncodeit-io/ncd-cicd-pipeline-to-k8s.git
* click on `Fork` to get a copy of the repository into your account
* in the repository, open file `Jenkinsfile`  and update `DOCKER_IMAGE_NAME` value with your dockerhub account details 
* Run the build and confirm that the image is pushed to your dockerhub account
---

#### :weight_lifting:  setup pipeline to build helm 
* Before we create our own helm chart lets try an existing helm chart from a public repository 
* Add bitnami helm repo to helm and download a nginx helm chart in .tgz format and launch a webserver in EKS cluster using this chart
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
* Lets pull a public helm chart , tag it and push it to our private repository 
```
mkdir $HOME/my-private-nginx
cd $HOME/my-private-nginx
helm repo add bitnami https://charts.bitnami.com/bitnami    # add bitnami helm repo to local helm installation
helm search repo bitnami/nginx      # search for nginx
helm pull bitnami/nginx --version 8.8.1               # pull the nginx chart in tgz format from bitnami repository
# this will download nginx-8.8.1.tgz file to local server 
ls -ltr                                               # you should see the nginx-8.8.1.tgz file 
tar zxvf nginx-8.8.1.tgz                              # extract the chart archive file and see the general contents
helm s3 push nginx-8.8.1.tgz stable-myapp             # push the tgz file to your own s3-helm repo
helm search stable-myapp/nginx                        # you should see nginx in your own repo now

```



* Now, lets try to create our own helm chart , package it and push the chart to s3-helm-repo
```
helm create train-schedule                                        # create the helm chart directory structure
cd train-schedule
nano values.yaml                                                   # open the values.yaml file and update the values

image:
  repository: <your-dockerhubid>/train-schedule
  pullPolicy: IfNotPresent
  tag: latest
  
service:
  name: train-schedule
  type: LoadBalancer
  port: 80

helm lint                                   # run a linter on helm chart to check for syntax errors
helm package train-schedule --debug                           # helm chart will be created in the form of tgz file

helm s3 push train-schedule-0.1.0.tgz stable-myapp            # Push the newly created chart to s3-helm repo 
helm repo index myapp/ --url s3://<bucket-name>/stable/myapp/       # add the newly pushed chart to the index file
helm repo list
helm search repo stable-myapp/train-schedule                  # search the repo "stable-myapp" for a chart "train-schedule"
```
---
#### :weight_lifting: deploy helm chart to kubernetes 
* Install the helm chart available at s3-helm-repo to the EKS cluster

```
helm install -n train-schedule010 stable-myapp/train-schedule
```
#### :weight_lifting: check if the newly deployed service is running
* check the services running on EKS cluster
```
kubectl get svc -A              # get services running on all namesspaces
# you should see train-schedule service also running.
```
* get the __EXTERNAL_IP__ of the service. This is the ALB created by the EKS cluster to allow ingress traffik 
* open the url `http://<EXTERNAL_IP>` in the browser and you should see the application


#### :weight_lifting: Cleanup 
* delete the EKS cluster  *(Use the eksctl command to delete. Do not delete from management console)*
* terminate the jumpbox ec2 instance  *(from management onsole)*
* delete the s3 bucket    *(from management onsole)*
----
# :clap: :thumbsup: Well DONE