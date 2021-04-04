## Pipeline2  - Containers based pipeline 
### Architecture
![Logical Flow of the pipeline](https://i.gyazo.com/8feccdb32a01e3001487bca6089f363d.png)

### Summary steps : 
* setup dockerhub account and a repository
* setup helm repository in s3
* setup EKS cluster
* setup jenkins pipeline to build docker image 
* setup pipeline to build helm
* deploy helm chart to kubernetes 

### Detailed steps : 
#### setup dockerhub account and repository 
* create dockerhub account
* create repository with the same name as the image name that will be build later. In this lab, we are creating an image with name `ncd-microservice-ui` . So, the repository name will be `ncd-microservice-ui` __NOTE__: repo name should be exactly same as image name
    + If you make mistake while creating repos, then delete the repo and recrete 
* 


#### setup jenkins pipeline to build docker image
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


