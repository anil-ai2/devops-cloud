### :camel: command based tasks
---
### Environment
* [click this link and open the image to understand the environment first](https://docs.google.com/presentation/d/1Lu_wB5WgMuNjfz6xb57iTuvgrrF4GHRwrKuKTMHOo_M/edit?usp=sharing)

    + A ubuntu server will be launched and it will setup another 6 ubuntu servers
    + So, a total of 7 servers are launched for your lab work
    + first ubuntu server is `jumpserver`, remaining 6 servers are `internal servers`
    + you have to use `internal servers` only for anisble workshop
    + do not install anything on the `jumpserver`
    + `1st internal server` - `ncodeitubnt1` can be used as `Ansible Controller`
    + remaining `5 internal servers` can be used as `inventory`

#### Task1: setup/check environment of of 7 ubuntu servers
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
exit    # exit out of ncodeitubnt1 
```

#### Task2: install Ansible ncodeitubnt1 and this will be controller
* make sure you are on the `jumpserver` 
```
ip a    # check the ip and make sure its jump server
ansible --version        # check if ansible already exists
sudo apt autoremove ansible  #remove default ansible

# clone git repo that has ansible installation script 
git clone https://github.com/ncodeit-io/devops-cloud-public-repo.git    

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
* from `jumpserver`, ssh to `ansible controller (ncodeitubnt1)` and create inventory file `ansible-inventory.ini`
```
# open a new terminal on jumpserver 
ssh ncodeitadm@ncodeitubnt1     # login to controller node

mkdir $HOME/ansible-controller ; cd $HOME/ansible-controller

nano ansible-inventory.ini
# copy paste below content in this file
[master]
ncodeitubnt1	ansible_host=<ip-of-ncodeitubnt1>

[group1-servers]
ncodeitubnt2	ansible_host=<ip-of-ncodeitubnt2>
ncodeitubnt3	ansible_host=<ip-of-ncodeitubnt3>
ncodeitubnt4	ansible_host=<ip-of-ncodeitubnt4>

[group2-servers]
ncodeitubnt5	ansible_host=<ip-of-ncodeitubnt5>
ncodeitubnt6	ansible_host=<ip-of-ncodeitubnt6>

[all:children]
master
group1-servers
group2-servers
 
#replace <ip-of-xxx> with actual ip available in /tmp/hosts.txt

#press ctrl+o , Enter , ctrl+x to save and exit the file

cat ansible-inventory.ini   # make sure all the servers are listed properly
```

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
* syntax is `ansible -i <inventory-file> [singleserver or group-of-servers as definedin inventory] -m [module] -a "[module options]"`
```
ip a    # make sure you are on controller. 

cd $HOME/ansible-controller
ansible -i ./ansible-inventory.ini group1-servers -a "ip a" -u ncodeitadm  #run the "ip a" command on group1-servers1

ansible -i ./ansible-inventory.ini all -m ping

ansible -i ./ansible-inventory.ini all -m command -a uptime
ansible -i ./ansible-inventory.ini all -m shell -a uptime
ansible -i ./ansible-inventory.ini all -a uptime
ansible -i ./ansible-inventory.ini group2-server -a "free -m"

# create a new directory with 755 permisssion using file module
ansible -i ./ansible-inventory.ini group1-server -m file -a "path=/home/ncodeitadm/abc state=directory mode=0755"

# copy a file from controller to a group of nodes in inventory 
ansible -i ./ansible-inventory.ini group1-server -m copy -a "src=/etc/hosts dest=/tmp/etc-hosts-from-controller"
```


#### Task6: run a playbook to install httpd on hosts in [master] group
* Lets get to the real ansible now. Lets start using ansible playbooks 
```

```

#### Task7: run a playbook to install nginx on all hosts in [group1-servers]
#### Task8: run a playbook to install nginx on all hosts in [group2-servers]
#### Task9: download jenkins role from ansible-galaxy and install on [group1-servers]and [group2-servers]
#### Task10: login to awx and explore the interface
---
---
### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 