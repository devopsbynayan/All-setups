#!/bin/bash

# Install Java 17
sudo dnf install java-17-amazon-corretto -y

# Download and extract Tomcat 10
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.42/bin/apache-tomcat-10.1.42.tar.gz
tar -xzf apache-tomcat-10.1.42.tar.gz
cd apache-tomcat-10.1.42

# Add manager user
sed -i '/<\/tomcat-users>/i\
<role rolename="manager-gui"/>\n\
<role rolename="manager-script"/>\n\
<user username="tomcat" password="raham123" roles="manager-gui,manager-script"/>' conf/tomcat-users.xml

# Disable IP restrictions for manager
sed -i '/RemoteAddrValve/ s/^/<!-- /; s/$/ -->/' webapps/manager/META-INF/context.xml

# Start Tomcat
./bin/startup.sh
