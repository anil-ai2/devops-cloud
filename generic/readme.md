#### ssh tunnel
![ssh tunnrl flow](https://www.tunnelsup.com/images/ssh-local2.png)
* __PURPOSE:__ consider a scenario 
    + Greenserver is an internal server that is only accessible from RED SERVER
    + Blueserver can ssh into Redserver but directly can not ssh into Greenserver
    + Assume a apache server is running on Greenserver
    + we want to access the apache on GREEN server to be accessble on BLUE SERVER Browser

    + on Blueserver , open a terminal and start a ssh tunnel 
    `ssh -N  {red-server-username}@{red-server-ip}   -L {port-on-BLUESERVER}:{GREENSERVER-IP}:{PORT-ON-GREENSERVER}`
    + for eg: for the tunnel as shown in the diagram , run the following command on Blueserver
    `ssh -N ncodeitadm@192.168.0.2  -L 8080:192.168.0.3:80`
    + Above command will as for the password of user `ncodeitadm` on `192.168.0.2` . Enter the password and the cursor will be blinking without any output. Thats the ssh tunnel 
    + keep this session running 
    + open a browser and access the url `http://loccalhost:{port-on-BLUESERVER-as-given-in-ssh-command}`


* Multiple SSH tunnels can be opened to different servers from BlueServer

