#!/bin/bash
echo "installing java before starting using other script in this repo"
cd /opt
echo "Download Nexus tar file"
wget http://download.sonatype.com/nexus/3/nexus-3.22.0-02-unix.tar.gz
echo "Extract the tar file"
tar -xvf nexus-3.22.0-02-unix.tar.gz
echo "Rename the nexus tar file to nexus"
mv nexus-3.22.0-02 nexus
echo "make user changes in nexus.rc"
sed -i 's/#run_as_user=""/run_as_user="root"/' /opt/nexus/bin/nexus.rc
echo "Modify memory settings"
sed -i 's/2703/512/' /opt/nexus/bin/nexus.vmoptions
echo "create nexus.service file"
touch /etc/systemd/system/nexus.service
echo "[Unit]" >> /etc/systemd/system/nexus.service
echo "Description=nexus service" >> /etc/systemd/system/nexus.service
echo "After=network.target" >> /etc/systemd/system/nexus.service
echo "[Service]" >> /etc/systemd/system/nexus.service
echo "Type=forking" >> /etc/systemd/system/nexus.service
echo "LimitNOFILE=65536" >> /etc/systemd/system/nexus.service
echo "User=root" >> /etc/systemd/system/nexus.service
echo "Group=root" >> /etc/systemd/system/nexus.service
echo "ExecStart=/opt/nexus/bin/nexus start" >> /etc/systemd/system/nexus.service
echo "ExecStop=/opt/nexus/bin/nexus stop" >> /etc/systemd/system/nexus.service
echo "User=root" >> /etc/systemd/system/nexus.service
echo "Restart=on-abort" >> /etc/systemd/system/nexus.service
echo "[Install]" >> /etc/systemd/system/nexus.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/nexus.service

chmod 755 /etc/systemd/system/nexus.service

echo "start nexus service"
serv=nexus
sstat=$(pidof $serv | wc -l )
if [ $sstat -gt 0 ]
then
echo "$serv running!!"
else
systemctl start $serv
echo "$serv service is UP now!!!"
fi
echo "you can access it in the browser by URL — http://public_dns_name:8081 . Wait for couple of minutes before the url is accessible"
echo "default username is admin, password is `cat /opt/sonatype-work/nexus3/admin.password` "
