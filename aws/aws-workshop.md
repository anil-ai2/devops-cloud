### :camel: command based tasks
---
<<<<<<< HEAD
#### Task1: Creating a New User with Limited Permissions Using the AWS Management Console

#### Task2: 
#### Task3:
=======
#### Task1: IAM User and Policies Hands on
           ``Create IAM user and open two tabs(one for root and the other for IAM user)   IAM user with full admin access
            create IAM user and log in using iam user
            give Admin access and click on security credentials
            create access key and download the access key
            run $aws configure #from cmd prompt 
            ##Download and install aws cli on your machine using below link
              https://awscli.amazonaws.com/AWSCLIV2.msi
            enter access key id
            enter secret access key
            region- eu-west-1

             Create new group using IAM user
             Group Name: developers
             Go to Groups from root user and remove IAM user from group
             got to IAM user and refresh the page on IAM users 	
             from root user, add IAM Read only Access
             IAM Read only access
             try to create the group from the IAM user

            Add Admin access to IAM user and then detach IAM user from IAMReadOnlyAccess
            Jump onto Policies from root user
            open Adminstrator Access(Click on Policy Summary & JSON code)
            do the same for IAM readonly access``
#### Task2:IAM role creation 
            Login using IAM user 
            Go to IAM roles
            Create role
            Select ec2(under common use cases)
            next
            Administrator Access 
            Next 
            Next  
            give role name : ec2role
            Create role
#### Task3: Ec2 Launch
            Click on services -> Select ec2 service
            Instances (running)  -> Launch Instance
            Search for Ubuntu -> select 18.04 version(AMI ID: ami-02fe94dee086c0c37)
            Ensure t2.micro is selected -> Next
            Next -> Next Add storage(give volume size as 8GB)
            Configure Security Group -> 
                  Type: SSH
                  Protocol: Tcp
                  Port Range: 22
                  Source : custom [0.0.0.0/0]
                        
            Click on Review and Launch
            Launch -> Create new Key pair
            give a name to Key Pair and Download it
            Launch Instance
>>>>>>> a7a91e4df39c5bf12d332bd2d53670ddf83f5185
#### Task4:
#### Task5:
#### Task6:
#### Task7:
#### Task8:
#### Task9:
#### Task10:
---
---
### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 
