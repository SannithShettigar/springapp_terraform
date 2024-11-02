#!/bin/bash
cd
sudo yum update -y
sudo yum install docker containerd git screen -y
sleep 1

#Install Docker Compose
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sleep 1
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/libexec/docker/cli-plugins/docker-compose
sleep 1
chmod +x /usr/libexec/docker/cli-plugins/docker-compose
sleep 5

#Enable and start Docker Service
systemctl enable docker.service --now


#Add users to Docker group 
sudo usermod -a -G docker ssm-user
sudo usermod -a -G docker ec2-user


#Restart the Docker Service
#systemctl status na docker.service
systemctl restart docker.service


#Pull Docker Image and Run it
docker pull karthik0741/images:petclinic_img
docker run -e MYSQL_URL=jdbc:mysql://${mysql_url}/petclinic \
           -e MYSQL_USER=petclinic \
           -e MYSQL_PASSWORD=petclinic \
           -e MYSQL_ROOT_PASSWORD=root  \
           -e MYSQL_DATABASE=petclinic  \
           -p 80:8080 docker.io/karthik0741/images:petclinic_img

