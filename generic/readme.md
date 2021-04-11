#### ssh tunnel
![ssh tunnrl flow](https://www.tunnelsup.com/images/ssh-local2.png)
* __PURPOSE:__ consider a scenario 
    + `GreenServer` is an internal server that is only accessible from `RedServer`
    + `BlueServer` can ssh into `RedServer` but directly can not ssh into `GreenServer`
    + Assume an apache server is running on `GreenServer`
    + we want to access the apache on `GreenServer` from a browser window opened on  `BlueServer`

    + on `BlueServer` , open a terminal and start a ssh tunnel 
    `ssh -N  {red-server-username}@{red-server-ip}   -L {any-port-on-BLUESERVER}:{GREENSERVER-IP}:{PORT-ON-GREENSERVER}`
    + for eg: for the tunnel as shown in the diagram , run the following command on `BlueServer`
    `ssh -N ncodeitadm@192.168.0.2  -L 8080:192.168.0.3:80`
    + Above command will ask for the password of user `ncodeitadm` on `192.168.0.2` . Enter the password and the cursor will be blinking without any output. Thats the ssh tunnel 
    + keep this session running 
    + open a browser window on `BlueServer` and access the url `http://localhost:{port-on-BLUESERVER-as-given-in-ssh-command}`
    + in case of the above example `http://localhost:8080`

* Multiple SSH tunnels can be opened to different servers from `BlueServer`

