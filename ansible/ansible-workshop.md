### :camel: command based tasks
---
### Environment
![Environment Architecutre for this lab](https://i.gyazo.com/a6a4982baf04bd6ff25a966fbc65e556.png)
* [click this link and open the image to understand the environment first](https://docs.google.com/presentation/d/1Lu_wB5WgMuNjfz6xb57iTuvgrrF4GHRwrKuKTMHOo_M/edit?usp=sharing)

    + A ubuntu server will be launched and it will setup another 6 ubuntu servers
    + So, a total of 7 servers are launched for your lab work
    + first ubuntu server is `jumpserver`, remaining 6 servers are `internal servers`
    + you have to use `internal servers` only for anisble workshop
    + do not install anything on the `jumpserver`
    + `1st internal server` - `ncodeitubnt1` can be used as `Ansible Controller`
    + remaining `5 internal servers` can be used as `inventory`

### __Note for katacoda session : If the session closes at any point, you can relaunch the session and finish Task1,Task2,Task3,Task4 then jump to any other task afterwards. First 4 tasks are for settingup the ansible environment

#### Task1: setup/check environment of of 7 ubuntu servers
* Wait until the environment is launched. __It will take about 5 minutes to launch the environment__
* copy the IP/hostname of all the servers once the katacoda scenario has started. You will need them later
* check the connectivity from `jumpserver` to all `internal servers`
```
ip a        # check jumpserver IP
cat /etc/hosts      # check hosts file. All 6 servers of ansible lab are here
ping ncodeitubnt1   # check connectivity to ncodeitubnt1
ping ncodeitubnt2   # check connectivity to ncodeitubnt2
ping ncodeitubnt3   # check connectivity to ncodeitubnt3
ping ncodeitubnt4   # check connectivity to ncodeitubnt4
ping ncodeitubnt5   # check connectivity to ncodeitubnt5
ping ncodeitubnt6   # check connectivity to ncodeitubnt6

ssh ncodeitadm@ncodeitubnt1     # ssh to ncodeitubnt1. password 'ncodeit123'
exit    # exit out of ncodeitubnt1 . 
```

#### Task2: install Ansible on "ncodeitubnt1" and this will be "controller"
* click on __Terminal__ and open a session on  `jumpserver` . Then ssh to Ansible controller machine `ncodeitubnt1`
```
ip a    # check the ip and make sure its jump server
ssh  ncodeitadm@ncodeitubnt1        # ssh from jump server to ncodeitunbt1
ansible --version        # check if ansible already exists. 
sudo apt autoremove ansible  #remove default ansible, if it exists

# clone git repo that has ansible installation script 
cd $HOME && git clone https://github.com/ncodeit-io/devops-cloud-public-repo.git    

cd devops-cloud-public-repo
chmod 755 install-ansible.sh
sudo ./install-ansible.sh   #install ansible2.9
ansible --version   # check ansible version. should be 2.9
```
* now ansible is installed on controller. There is no need to install ansible anywhere else. 
* All nodes in the inventory file will be accessible through ssh

#### Task3: create the inventory file 
* copy the list of IPs and hostnames from `jumpserver` 
```
ip a    # make sure is jumpserver
cat /tmp/hosts.txt      # this file has IPs and hostnames.
# you need to create the inventory file using these IPs and hostnames
```
* from `jumpserver`, ssh to `ansible controller (ncodeitubnt1)` , create a separate directory for all the files related to ansible and copy existing inventory file `ansible-inventory.ini`
```
# open a new terminal on jumpserver 
ssh ncodeitadm@ncodeitubnt1     # login to controller node

mkdir $HOME/ansible-controller ; cd $HOME/ansible-controller    #create a directory for all the ansible related files

cp /tmp/ansible-inventory.ini $HOME/ansible-controller/ansible-inventory.ini  # copy a pre-created inventory file

cat $HOME/ansible-controller/ansible-inventory.ini   # make sure all the servers are listed properly
```
* __NOTE: we are not using the /etc/ansible/hosts file. Instead we are using a custom inventory file ansible-inventory.ini__

#### Task4: setup password-less ssh login from controller to all nodes in inventory
* login from `jumpserver` to `ansible controller(ncodeitubnt1)`
* generate certificate & key on controller node using `ssh-keygen`
* copy the key to all nodes in the inventory using `ssh-copy-id`
```
ip a    # make sure you are on jump server
ssh ncodeitadm@ncodeitubnt1     # login to controller
ssh-keygen                      # press enter for all questions to use default values 
ssh-copy-id  ncodeitadm@ncodeitubnt1        # copy the key to controller itself. Provide password first time
ssh-copy-id  ncodeitadm@ncodeitubnt2        # copy the key to ncodeitubnt2. Provide password first time
ssh-copy-id  ncodeitadm@ncodeitubnt3        # copy the key to ncodeitubnt3. Provide password first time
ssh-copy-id  ncodeitadm@ncodeitubnt4        # copy the key to ncodeitubnt4. Provide password first time
ssh-copy-id  ncodeitadm@ncodeitubnt5        # copy the key to ncodeitubnt5. Provide password first time
ssh-copy-id  ncodeitadm@ncodeitubnt6        # copy the key to ncodeitubnt6. Provide password first time

# check if ssh login is working to all nodes without password

ssh ncodeitadm@ncodeitubnt1     # login to ncodeitubnt1 . should not ask for password
exit                            # exit out of ssh sesion. You are back in ncodeitubnt1 main session 

ssh ncodeitadm@ncodeitubnt2     # login to ncodeitubnt2 . should not ask for password
exit                            # exit out of ssh sesion. You are back in ncodeitubnt1 main session 

ssh ncodeitadm@ncodeitubnt3     # login to ncodeitubnt3 . should not ask for password
exit                            # exit out of ssh sesion. You are back in ncodeitubnt1 main session 

ssh ncodeitadm@ncodeitubnt4     # login to ncodeitubnt4 . should not ask for password
exit                            # exit out of ssh sesion. You are back in ncodeitubnt1 main session 

ssh ncodeitadm@ncodeitubnt5     # login to ncodeitubnt5 . should not ask for password
exit                            # exit out of ssh sesion. You are back in ncodeitubnt1 main session 

ssh ncodeitadm@ncodeitubnt6     # login to ncodeitubnt6 . should not ask for password
exit                            # exit out of ssh sesion. You are back in ncodeitubnt1 main session 

```

* if you are able to login to all hosts in the inventory without password then your ansible setup is ready

#### Task5: run some adhoc commands
* all adhoc commands are run using `ansible` command
* syntax is `ansible -i <inventory-file> [singleserver or group-of-servers as defined in inventory] -m [module] -a "[module options]"`
```
# Be on "jumpserver". And from "jumpserver" ssh to ansible-controller "ncodeitubnt1"
ssh ncodeitadm@ncodeitubnt1

ip a    # make sure you are on controller "ncodeitubnt1"

cd $HOME/ansible-controller
export ANSIBLE_HOST_KEY_CHECKING=False    # to disable hostname verification by ansible
ansible -i ./ansible-inventory.ini all -m ping      # ping all the servers

ansible -i ./ansible-inventory.ini group1servers -a "ip a" -u ncodeitadm  #run the "ip a" command on group1servers1

ansible -i ./ansible-inventory.ini all -m command -a uptime             # use module "command" to run "uptime" command
ansible -i ./ansible-inventory.ini all -m shell -a uptime               # use model "shell" to run "uptime" command
ansible -i ./ansible-inventory.ini all -a uptime                        # run an adhoc command using -a option
ansible -i ./ansible-inventory.ini group2servers -a "free -m"            # run an adhoc command only on "group2servers"

# create a new directory with 755 permisssions using file module on all "group1servers"
ansible -i ./ansible-inventory.ini group1servers -m file -a "path=/home/ncodeitadm/abc state=directory mode=0755"

# ssh to "ncodeitubnt2" server and check if the directory is actually created
ssh ncodeitadm@ncodeitubnt2
cd /home/ncodeitadm 
ls -ltr             # you should see abc directory. You can check other servers also 
exit                # get back to "ncodeitubnt1" , our ansible-controller server again
# 

cd $HOME/ansible-controller 

# copy a file from controller to a group of nodes in inventory 
ansible -i ./ansible-inventory.ini group2servers -m copy -a "src=/etc/hosts dest=/tmp/etc-hosts-from-controller"
```


#### Task6: run a playbook to install httpd on nodes in [master] group
* Lets get to the real ansible now. Lets start using ansible playbooks 
* start with a simple one. Install apache2 server on all the inventory
* you should see the below nice output from ansible (as shownn in image) after the installation of apache2 is completed 
* __OK__ in `green`  - __changed__ in `yellow` - __failed__ in `red` 

![Apache installation completed on all the 6 vms](https://i.gyazo.com/b74890f4d5dd27ba8beafda575fdbc43.png)

```
cd $HOME/ansible-controller
curl -OL https://raw.githubusercontent.com/ncodeit-io/devops-cloud-public-repo/main/ansible-playbooks/apache.yml    #download the playbook 

cat apache.yml      # observe the hosts,tasks and modules options 
ansible-playbook apache.yml -i ./ansible-inventory.ini --ask-become-pass        # run the playbook. Provide password if asked

# ssh to one of the vms in inventory and check if apache2 is installed 

```
#### Task7: run a playbook to install nginx on all nodes in group [group1servers]
* use nginx.yml playbook to install nginx server only on few of the inventory hosts
```
cd $HOME/ansible-controller
curl -OL https://raw.githubusercontent.com/ncodeit-io/devops-cloud-public-repo/main/ansible-playbooks/nginx.yml    #download the playbook

cat nginx.yml       # observe that "hosts" is defined as all. But still we will try to limit the hosts to only some

ansible-playbook nginx.yml -i ./ansible-inventory.ini --ask-become-pass -l group1servers    # use "-l" option to run on subset of hosts

```

#### Task8: go to ansible galaxy site and search for some roles created by others
* Lets use some ansible playbooks created by others. ie. playbooks given to us as roles 
* we will download the role and then create a small playbook to run the role
* go to website https://galaxy.ansible.com  ; click "cloud" and search for "geerlingguy". He is one of the famous people in ansible 
* check the various roles he created
* search for roles by other members related to "jenkins" , "docker" , "mysql"
#### Task9: download java role from ansible-galaxy
```
# check ansible-galaxy version 
ansible-galaxy --version

# search the role in galaxy.ansible.com from commandline 
ansible-galaxy search "java for linux" --author geerlingguy     

# download the role from galaxy to $HOME/.ansible/roles/geerlingguy.java on ansible-controller
sudo ansible-galaxy install geerlingguy.java

cd $HOME/.ansible/roles/geerlingguy.java ; ls -ltr  # check the general directories in any role, defaults, vars etc.
```
### Task10: Install the java role on nodes in the group [group2servers]
* roles can not be executed directly. You need to add them to a playbook always
* lets create a simple playbook
* copy/paste the 6 lines of code on prompt. It will create java.yml playbook. This playbook will call geerlingguy.java role that we have just downloaded 
```
cd $HOME/ansible-controller
cat <<HERE > java.yml
---
- hosts: all
  become: yes
  roles:
  - geerlingguy.java
HERE
```
* Lets run the `java.yml` playbook now , which calls `geerlingguy.java` role 
```
cd $HOME/ansible-controller
ansible-playbook java.yml -i ./ansible-inventory.ini --ask-become-pass -l group2servers
```
---
---
