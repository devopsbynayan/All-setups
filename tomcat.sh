# Step 1: Install Java 17
sudo yum install java-17-amazon-corretto -y

# Step 2: Download Apache Tomcat 9.0.105
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.105/bin/apache-tomcat-9.0.105.tar.gz

# Step 3: Extract Tomcat archive (correct filename)
tar -zxvf apache-tomcat-9.0.105.tar.gz

# Step 4: Configure tomcat-users.xml to add manager roles and user
sed -i '56 a\<role rolename="manager-gui"/>' apache-tomcat-9.0.105/conf/tomcat-users.xml
sed -i '57 a\<role rolename="manager-script"/>' apache-tomcat-9.0.105/conf/tomcat-users.xml
sed -i '58 a\<user username="tomcat" password="raham123" roles="manager-gui,manager-script"/>' apache-tomcat-9.0.105/conf/tomcat-users.xml
sed -i '59 a\</tomcat-users>' apache-tomcat-9.0.105/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-9.0.105/conf/tomcat-users.xml

# Step 5: Remove lines 21 and 22 from context.xml (disable manager app restrictions)
sed -i '21,22d' apache-tomcat-9.0.105/webapps/manager/META-INF/context.xml

# Step 6: Start Tomcat server
sh apache-tomcat-9.0.105/bin/startup.sh
