#!/bin/bash

echo "update your vm"
apt-get -y update

echo "Installing java version 8"
apt install -y openjdk-8-jdk

echo "check java version"
java -version

echo "export java varaibales"

echo "JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64/bin/java"" >> /etc/environment

echo "Restart source file"
source /etc/environment
echo "check JAVA_HOME path"
echo $JAVA_HOME
