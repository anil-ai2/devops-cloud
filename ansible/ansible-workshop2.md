### additional tasks 
#### setup ssh-keys between controller and inventory 
- lets assume the following inventory 
```
control-node    10.10.10.10
inventory-node     20.20.20.20
```
- enable password based user authentication on all servers

```
# execute below commands on both the servers
sudo sed -i '/^PasswordAuthentication/s/no/yes/' /etc/ssh/sshd_config  # change PasswordAuthentication to yes
sudo systemctl restart sshd   # resetart sshd
```

- create a new user `ztrixadm` and setup password `ztrix123` . Add sudo previleges also 
```
# run it on all servers
sudo useradd -p "$(openssl passwd -1 ztrix123)" -m -d /home/ztrixadm -s /bin/bash -G sudo,admin ztrixadm
```

#### copy ssh public key of control node to inventory 
- login to `control-node` and generate ssh key 
```
id  # make sure its ztrixadm

[ ! -d .ssh ] && mkdir ~/.ssh                       # create directory .ssh if it does not exist 

ssh-keyscan 20.20.20.20 >> ~/.ssh/known_hosts       # repeat this process for all the inventory files. Replace the IP with correct one
ssh-keygen -t rsa 
ssh-copy-id ztrixadm@20.20.20.20                    # provide the password "ztrix123"

exit                                                # exit from remote node and get back to control node

# repeat this ssh-copy-id command from control-node to all the nodes in the inventory 
```
#### test the passwordless ssh 
```
# login to control node using ztrixadm . Then connect to the inventory node. Make sure it does not ask for any password

ssh ztrixadm@20.20.20.20        # it should not ask any password. Special note: make sure you are under correct username 
```

