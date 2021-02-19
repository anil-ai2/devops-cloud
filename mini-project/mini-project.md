### :camel: setup and maintain a end-to-end CICD pipeline with github,Jenkins,Nexus,Dockerhub,Helm,K8s on AWS(EKS)
---
### Architecture 
![Architecture of Project k8s&aws](https://i.gyazo.com/6e66f96059ab7628491ae496bc595bf6.png)

* *this is only a partial architecture diagram

### 
* Git and github for source code 
* Jenkins to run jobs that will build docker images and helm charts
* Nexus OSS to store the artifacts and helm charts
* dockerhub as a repository for docker images 
* Helm package manager to deploy helm chart based applications to EKS cluster (through jenkins pipelines)
* AWS Elastic Kubernetes Service (EKS) to host the application 
* traefik or nginx ingress controller to redirect the traffic to internal k8s services
* aws ALB (Application Load Balancer) to receive the external traffic and redirect to ingress controller

### Build and destroy EKS cluster
* create IAM role that will creat the EKS cluster
* create IAM role that will create workernode groups
* create VPC for the EKS cluster
* create EKS cluster
* create workders
* setup awscli, kubectl , aws-iam-authenticator








### aws account cleanup using cloud-nuke command 
* Install `aws cli`
* install `cloud-nuke`
* run `cloud-nuke aws`
