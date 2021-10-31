### Setup the Infrastructure
#### setup 3 EC2 instances
    type : t2.micro 
    tag  : ncdec21 (1st ec2 instance) 
    tag  : ncdec22 (2nd ec2 instance) 
    tag  : ncdec23 (3rd ec2 instance)
		
#### Enable public IP to all the instances 
#### open all ports for http/https traffic ( ingress) 
	
### setup the following configuration on each server : 
- install nginx server at port `80`
    - `take a screenshot of the default page and post to slack`
- install apache server at port `9000`
    - `take a screenshot of the default page and post to slack`
- install tomcat server at port `8080`
    - `take a screenshot of the default page and post to slack`
		

- install docker and start the docker daemon 
    - launch the following containers with the configuration as given 
        - __*jenkins container*__
            - name : jenkins-slim 
            - image : jenkins/jenkins:2.263.3-lts-slim
            - container port : 8080
            - host port : 8888 
        
            - `take a screenshot of the default page and post to slack`

        - __*apache container*__
            - name : ncd-apache1
            - image : httpd
            - container port: 80
            - host port : 8888

            - `take a screenshot of the default page and post to slack`