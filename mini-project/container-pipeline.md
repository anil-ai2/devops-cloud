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
helm plugin install https://github.com/hypnoglow/helm-s3.git
helm s3 init s3://<bucket-name>/stable/myapp/                       #replace <bucket-name> with your bucket name
aws s3 ls s3://<bucket-name>/stable/myapp/                          #replace <bucket-name> with your bucket name
helm repo add stable-myapp s3://<bucket-name>/stable/myapp/         #replace <bucket-name> with your bucket name
helm repo list
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

* Fork repository https://github.com/ncodeit-io/ncd-cicd-pipeline-to-k8s.git into your account 
* in the repository, open file `Jenkinsfile`  and update `DOCKER_IMAGE_NAME` value with your dockerhub account details 
* Run the build and confirm that the image is pushed to your dockerhub account
---

#### :weight_lifting:  setup pipeline to build helm 
* Before we create our own helm chart lets try an existing helm chart from a public repository 
```
helm repo add bitnami https://charts.bitnami.com/bitnami            # add bitnami public repository
helm search repo bitnami nginx                                  # search "bitnami" repo for a chart "nginx"
helm install mywebserver bitnami/nginx                          # install helm chart nginx with name "mywebserver"
kubectl get all -A                                              # you should see the "myserver" deployment 
helm list                                                       # should show the installed helm chart 

```
* go ahead and UNINSTALL the chart
```
helm uninstall mywebserver                                      # uninstall the nginx application
```
* create a helm chart , package it and push the chart to s3-helm-repo
```
helm create train-schedule                                        # create the helm chart directory structure
cd train-schedule
nano values.yaml                                                   # open the values.yaml file and update the values

image:
  repository: <your-dockerhubid>/train-schedule
  tag: latest
  pullPolicy: IfNotPresent
service:
  name: train-schedule
  type: LoadBalancer
  port: 80

helm lint                                   # run a linter on helm chart to check for syntax errors
helm package train-schedule --debug                           # helm chart will be created in the form of tgz file


helm repo index myapp/ --url s3://<bucket-name>/stable/myapp/       # convert the s3 bucket into a helm repo by generating index file

# at this step go to your s3 bucket and check if index.html file. This file will list all the charts available in the s3-helm repo

helm repo list                          # list all the repos that are currently added to helm tool in jumpbox.
# above command should show the newly added helm repository 

helm s3 push train-schedule-0.1.0.tgz stable-myapp            # Push the newly created chart to s3-helm repo 
helm repo list
helm search repo stable-myapp train-schedule                  # search the repo "stable-myapp" for a chart "train-schedule"
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
