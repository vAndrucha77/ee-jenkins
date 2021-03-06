# Docker EE (Datacentre) Example Jenkins CICD Setup

This is a repository to configure a fully functioning Jenkins CICD environment running on top of Docker Enterprise Edition (Docker EE). This is using the Docker Swarm Orchestrator within Docker EE.

## Build your images and push them to DTR (Distributed Trusted Registry)

Firstly we will build the required images for the Jenkins Environment. The pre-requisites for this include downloading your UCP Client Bundle and placing it within the the Jenkins-Master and Jenkins-Slave repository. We will use the certificates within this bundle later.

```
$ export DTR=https://
$ export VERSION=2.88

$ cd jenkins-master
$ docker build -t ${DTR}/admin/jenkins:${VERSION} .
$ docker push ${DTR}/admin/jenkins:${VERSION} 

$ cd ../jenkins-slave
$ docker build -t ${DTR}/admin/jenkins-slave:${VERSION} .
$ docker push ${DTR}/admin/jenkins-slave:${VERSION}
```

## Start your Jenkins Service

This can step can be done within the UCP UI or by sourcing the Client bundle and using the Docker Client.

```
$ unzip ucp-bundle-admin.zip
$ source env.sh

$ cd jenkins-master
$ docker stack deploy -c docker-compose.yml ci
```

## Configure Jenkins

Browse to the URL of Jenkins http://${UCP}:30000

Take the password from the jenkins container.

```
$ id=$(docker ps -q -f "name=ci_jenkins") 
$ docker exec ${id} cat /var/jenkins_home/secrets/initialAdminPassword
```

Login to the Jenkins appliancing with this password, installing all of the default plugins and confiruing a user.

### Configuring SSH

```
$ docker exec -it ${id} sh
/ $ ssh-keygen
/ $ cat ~/.ssh/id_rsa.pub
```

Copy accross this public key to your Github Account

- Github.com > Settings > SSH Keys

![Alt text](/images/githubsshkey.png?raw=true "Jenkins SSH Key")

```
/ $ ssh git@github.com
```

### Configuring Github Webhook

Settings > Webooks > Add the payload URL: http://${DTR}:30000/github-webhook/

![Alt text](/images/githubwebhook.png?raw=true "Github Webhook")

## Jenkins Plug-Ins Required

- Yet another Docker Plugin - Credentials Work now!
------- Git Plugin
------- Github API plugin
------- GitHub Authentication plugin - Required to use Access Tokens

## Jenkins Credentials

In Jenkins go to Credentials > System > Global Credentials (unrestricted)

Create Docker Host Certificate Authentication for Docker UCP

![Alt text](/images/jenkinscreds.png?raw=true "Jenkins Credentials")

--------Create a personal access token on Github. Within Jenkins go to Global Credentials and a secret text entry. Insert your Personall Access token here.

Head to Manage Jenkins > System Configuration

-------Scroll down to Github > Github Servers. Specify your secret text credentials from the list and test the conntection to github.

Create a new Cloud using the Yet another Docker Plugin. And test connectoin :)

![Alt text](/images/NewCloudConfig.png?raw=true "New Cloud Config")

Everything is now good to go for your Jenkins Config. 
Your now ready to build your Pipeline Jobs :)

### Pipeline instructions

## Configure Docker Template

Manage Jenkins > Configure System > Cloud > YAD > Add Docker Template

Docker Image Name: dtr.olly.dtcntr.net/admin/slave:latest

Create Container Settings >
 - Command bin/bash chown jenkins:jenkins /var/run/docker.sock
 - Volumes /var/run/docker.sock:/var/run/docker.sock
 - Run Container Privileged

Save

## Configure Credentials

System > Configure Credentials > System

- Create one with DTR User and Password
- Create one with Secret Text String for Notary Passphrase

