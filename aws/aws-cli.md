# aws cli related tasks 
---
### :camel: 
---
## Note: At any point of time after the lab is done, login to your aws account and delete the AccessKeyID,SecreatKey. Else you have exposed your account to serious security risk. You might loose lakhs of rupees. Careful with your credentials.
---
#### Task1: Install aws cli 
```
cd $HOME && git clone https://github.com/ncodeit-io/devops-cloud-public-repo.git
cd devops-cloud-public-repo/aws/aws-cli
./install_awscli2.sh
```
#### Task2: Download the Root User accessKeyID and SecretKey 
* login to aws management console 
* click on your username at right-side top corner -> My security Credentials -> Access Keys -> Create New Access Key -> Download Keyfile with name "ncd-awscli-lab-access-key" . This file will be on your laptop
* open the ncd-awscli-lab-access-key file and see the content. You will see `AWSAccessKeyId` and `AWSSecretKey` in that file . We will need these two values in next step
#### Task3: configure profiles for awscli & check the configuration files for the root user
* configure the awscli for root user
```
aws configure       # privide the AWSAccessKeyID and AWSSecretKey that were generated in earlier step. 
# for default regision "us-east-1" and for "default output format" give "json"
# if you made any mistakes, its ok, run the aws configure command again with correct values

cd ~/.aws           # this is the directory where configuration files profiles are available
ls -ltr             # you should see two files "config" and "credentials"
cat config          # configuration values of profiles
cat credentials     # credentials of root user
```
* check the version of awscli 
```
aws --version       # should be 2.x 
```
* Now lets go ahead  and create another user and the access key for that user 
* Login to Management console -> go to IAM -> Users -> Add User -> give username "awsclilab-user" -> for Access type , select "Prammatic access" -> click "Next:Permissions" -> click "Attach existing Policies Directly" -> select "AdministratorAccess" -> click "Next:Tags" -> click "Next:Review" -> click "Create user"
* copy `Access key ID` and `Secret access key` to a notepd. We need it later

* Lets configure 2nd proifle on awscli 
```
aws configure --profile awsclilab-user-profile    # create a new profile "awsclilab-user-profile"
# privide the AWSAccessKeyID and AWSSecretKey that were generated in earlier step. 
# for default regision "us-east-1" and for "default output format" give "json"
# if you made any mistakes, its ok, run the aws configure command again with correct values

cd ~/.aws           # this is the directory where configuration files of root user profile are available
ls -ltr             # you should see two files "config" and "credentials"
cat config          # configuration values of 2 profiles will be visible now
cat credentials     # credentials of both users will be visible in this file. This file should be deleted before ending the lab
```
* lets use one profile at a time to perform an activity on your aws account 
```
aws iam list-users --profile awsclilab-user-profile     # running commands with user awsclilab-user
aws iam list-users --profile default                    # running command with root user 

```

#### Task4: use environment variables instead of profiles
* download the base files 
```
cd $HOME && git clone https://github.com/ncodeit-io/devops-cloud-public-repo.git
cd devops-cloud-public-repo/aws/aws-cli 
cp user1-profile $HOME/awsclilab-user-profile
source $HOME/awsclilab-user-profile

```
* set `AWS_DEFAULT_PROFILE` parameter to switch between the profiles
```
aws iam list-users                                      # running command with root user 
aws configure list                                      # details related to "default" profile are shown

export AWS_DEFAULT_PROFILE="awsclilab-user-profile"     # setting "awsclilab-user-profile" profile as the current profile
aws configure list                                      # details related to "awsclilab-user-profile" profile are shown
```

#### Task5: EC2 related commands
* clone the repo that has all the awscli scripts
```
export AWS_DEFAULT_PROFILE="awsclilab-user-profile"     #setup the profile to "awsclilab-user-profile"
aws configure list                                      #confirm you are in correct profile
cd $HOME && git clone https://github.com/ncodeit-io/devops-cloud-public-repo.git
cd devops-cloud-public-repo/aws/aws-cli
aws ec2 describe-instances                              #list all the instances in your aws account 
```

* create a key-pair that can be used to access a future ec2 instance
```
aws ec2 create-key-pair --key-name ncodeit-ec2-keypair1     ##aws ec2 create-key-pair --key-name <key-pair-name>

```
* setup security group 
```
#aws ec2 create-security-group --group-name <securty-group-name>
aws ec2 create-security-group --group-name secgrp1-for-ec2 --description "security group for ec2 instance"

aws ec2 describe-security-groups --output table         # shows all the security-groups in the region

```
* copy the `GroupID` of the `security-group` in above step. We need it next
* get the `subnet-id` of one of the subnets of the region
```
aws ec2 describe-subnets        # describes all subnets 

```
* copy the `SubnetId` of `AvailabilityZone - us-east-1a` . We will need it in next step 

* create a new EC2 instance using the recently created `security-group` and `keypair`
```
cd $HOME && git clone https://github.com/ncodeit-io/devops-cloud-public-repo.git
cd devops-cloud-public-repo/aws/aws-cli 
nano create-ec2-instance.sh 
# replace `security_group_ids` and `subnet_id` with values of your account. We have gathered these details in previous steps
ctrl+s (save) , ctrl+x (exit)

cd $HOME/devops-cloud-public-repo/aws/aws-cli 
./create-ec2-instance.sh        # run the script to create one ec2 instace

aws ec2 describe-instances      # describe all the instances in the account 
```
* go to `aws management console` and check that the newly launched instance is coming up
* Lets launch 4 more instance using the same script
```
cd $HOME/devops-cloud-public-repo/aws/aws-cli 
nano create-ec2-instane.sh      # open the instance creation file 
#change count from 1 to 4
ctrl+s  , ctrl+x (save & exit)

./create-ec2-instance.sh        # run the script to create one ec2 instace

aws ec2 describe-instances      # describe all the instances in the account . This time you should see 5 instances total
```
* Terminate one instance 
```
aws ec2 describe-instances --output table     # notice the instance id column
aws ec2 terminate-instances --instance-ids <replace-with-instance-id>      #use first instance-id
aws ec2 describe-instances --output table     # one instance will be in terminating status. Remaining 4 should be in running

```
* go to `aws management console` and check the staus of ec2 instances

* stop/start/reboot the remaining instance 
```
aws ec2 describe-instances --output table     # notice the instance id
aws ec2 terminate-instances --instance-ids <instance2-id> <instance3-id>    # lets terminate two instances at a time
aws ec2 describe-instances --output table     # check the status of all the instances
aws ec2 reboot-instances --instance-ids <instance4-id> <instance5-id>
```
* List all running instances
```
cd $HOME/devops-cloud-public-repo/aws/aws-cli
./ec2-list-all-running-instances.sh
```
* List all running instances in table format
```
cd $HOME/devops-cloud-public-repo/aws/aws-cli
./ec2-list-all-running-instances-in-table-format.sh
```
* Get public IP of all running instances 
```
cd $HOME/devops-cloud-public-repo/aws/aws-cli
./ec2-get-publicIP-of-all-instances.sh
```
* Terminate all the instances 
```
aws ec2 describe-instances --output table     # notice the instance id
aws ec2 terminate-instances --instance-ids <instance2-id> <instance3-id>    # lets terminate all instances
```
* go to `aws management console` and make sure all the instances are in `Terminating` staus. If any instance is missing terminate it from command-line
#### Task6: s3 related activities
* general commands related to __s3__
```
aws s3 ls		# list all S3 buckets
aws s3 mb s3://ncd-bucket1-anil999000 --region us-east-1	#create s3 bucket 
aws s3 ls		                                            # check the newly created bucket
aws s3 rb s3://ncd-bucket1-anil999000 --force		# remove bucket

```
#### Task7: IAM related activities
* general commands related to __IAM__
```
aws iam list-users   --output table 	            # list all user's info
aws iam list-users  --output text | cut -f 6		# list all user's usernames
aws iam get-user		                        # list current user's info in json format 
aws iam get-user   --output table		        # list current user's info in table format 
aws iam get-user   --output text               # list current user's info in text

aws iam list-access-keys      # list current user's access keys
```
#### Task8: 
#### Task9: 
#### Task10:  

---