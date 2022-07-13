#!/bin/bash

# Install required packages.
amazon-linux-extras install nginx1
yum install -y curl bash-completion unzip

echo "<html>" > /usr/share/nginx/html/index.html
echo "<head>" >> /usr/share/nginx/html/index.html
echo "<title>Hello World</title>" >> /usr/share/nginx/html/index.html
echo "</head>" >> /usr/share/nginx/html/index.html
echo "<body>" >> /usr/share/nginx/html/index.html
echo "<h1>Hello World from " >> /usr/share/nginx/html/index.html
curl http://169.254.169.254/latest/meta-data/instance-id >> /usr/share/nginx/html/index.html
echo "</h1>" >> /usr/share/nginx/html/index.html
echo "</body>" >> /usr/share/nginx/html/index.html
echo "</html>" >> /usr/share/nginx/html/index.html
chmod 644 /usr/share/nginx/html/index.html
chown root /usr/share/nginx/html/index.html
chgrp nginx /usr/share/nginx/html/index.html

systemctl start nginx
systemctl enable nginx

yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl start amazon-ssm-agent
systemctl enable amazon-ssm-agent
