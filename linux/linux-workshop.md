### :camel: command based tasks
---
---
#### Task1: install ssh client
* download latest version of mobaxterm from https://mobaxterm.mobatek.net/download.html and install on your laptop

#### Task2: Login to Linux server/vm with username/password
* launch mobaxterm and connect to the linux server using IP/username/password provided 
#### Task3: Understand the system(pwd/ip/hostname/uname/date)
```
cd /tmp  # change current directory to /tmp
ip a     # IP address of the server
hostname #
uname    #
date     #
```
#### Task4: list/create/remove/rename files and directories 
```
cd /etc
pwd         # list current directory
ls -ltr     # list all files/directories in pwd
cd /home/ncodeit    # change directory to /home/ncodeit
touch f1 f2 f3  # create 3 empty files with names f1 f2 f3
rm -f       # remove file f1
mv f1 f1-new    # rename file f1 to new name f1-new

mkdir d1 d2 d3    # create 3 directories d1 d2 d3
mv d1 d1-new      # rename d1 to d1-new
mv f2 d2          # move file f2 into directory d2
rm -rf d3       # remove dir d3 ansub-directories
```
#### Task5: see the content in the files
```
cat /etc/passwd # see the content of file
head -5 /etc/passwd # top 5 rows of file
tail -1 /etc/passwd # last row of file 

```
#### Task6: edit a file
```
cd /home/ncodeit
nano f1

# press ctrl+o ctrl+x to save and exit
```
#### Task7: archive files and directories (zip/tar)
```
zip -r d1.zip d1  # zip d1 directory and sub-dirs
rm d1.zip      #remove the zip file
unzip d1.zip   # unzip the zip file
tar cvf d1.tar d  # create a tar file of d1 dir
mv d1.tar d999.tar # rename the tar file 
rm -rf d1.tar      # remove d1.tar file
tar xvf d999.tar   # extract the tar file 
```
#### Task8: storage (df/du)
```
df -h    # list the space on all file systems
du -sh * # size of each file and directory 

```
#### Task9: cpu/ram/load on the system - top/htop
```
free -m  # free memory/occupied memory 
top      # cpu/memory/load on the system. press q to exit
htop     # modern version of top

```
#### Task10: create/kill processes (ps/kill)
```
ps -ef  # list all processes running on system
kill -9 <PID>  # kill a process with process id PID

```
#### Task11: connect to remote systems (ping/ssh/scp)
```
ping google.com     # check google.com is reachable. Or internet is connected to this server
ping 192.168.12.2   # check server 192.168.12.2 is reachable

#ssh <username>@<ip-of-remote-server> - connect to <ip-of-remote-server> with username <username>
ssh ncodeit@192.168.12.10 

# transfer file from one system to other 
# scp <file1>  <username>@<ip-of-remote-server>:/tmp
cd /home/ncodeit
touch file1
scp file1 ncodeit@192.168.12.220:/tmp

```
#### Task12: write a shell script 
```
nano ncodeit-script1.sh
#copy following lines into above file
echo "Hi this is my script"
pwd     # current working directory
date    # current date 
hostname # hostname of this server
#press ctrl+o and ctrl+x to save the file
```
chmod 755 ncodeit-script1.sh  # give execute permissions to the scrpt

#### Task13: execute a file
```
cd /home/ncodeit
./ncodeit-script1.sh
#check the output of the above script
```
---
---
### :rocket: scenario based tasks 
---
#### scenario1: 
* _on a linux server you wanted to start a new program that will consume about 3GB of RAM. You were asked by your team lead to find out if your system has sufficient RAM. What do you do ? _
* __find out the total RAM and currently avaialble RAM on your system__
#### scenario2: 
* _while you are trying to copy a big movie file of 5GB into your linux server, you have encountered an error "Error: Not enough space on disk. What are the commands you would use to troubleshoot this problem ?"_ 
* __find out total storage and available STORAGE on your system__
#### scenario3: 
* _A directory (along with all the files) is accidentally removed from system2 by your collegue. These are very critical files and you need them on system2 immediately. At that very moment, you have realized that the same directory is also available in system2. Bring that directory, along with the files from system2 to system1 in the shortest time_
#### scenario4: 
* _you have logged into a linux server and you have observed that the server is abnormally slow. Any command you execute is taking very long time to complete. You suspect that some processes might be consuming too much CPU. Identify that process kill it to make the system work normally_
* __reduce the most cpu consuming process__
#### scenario5: 
* _your server is running for the last 270 days. It was never restarted in these 270 days. Because of this, some processes on this server are went into sleep mode. Your team lead has asked you to find out all the processes that have a word "sleep" in their name and kill all such processes_ 
* __find out the process with name "sleep" and kill it__