FROM alpine:3.6
LABEL maintainer="vAndrucha77"
LABEL versions="DockerClient17.10.0 Notary0.4.3"

RUN apk add --upgrade --no-cache \
    ca-certificates \
    openssh \
    openssh-server \
    git \
    bash \
    sudo \
    wget \
    curl && \
    rm -rf /var/cache/apk/*

# Configure Java 8
ENV JAVA_HOME /usr/lib/jvm/default-jvm
RUN apk add --no-cache openjdk8 && \
    ln -sf "${JAVA_HOME}/bin/"* "/usr/bin/"

# Copy Accross UCP Certs
COPY ucp-bundle-ci-pipeline.zip /home/jenkins/
RUN (unzip /home/jenkins/ucp-bundle-ci-pipeline.zip -d /home/jenkins/ && \
    cp /home/jenkins/ca.pem /usr/local/share/ca-certificates/ca.pem && \
    curl -k https://dtr.andreas.dtcntr.net/ca -o /usr/local/share/ca-certificates/dtr.andreas.dtcntr.net.crt && \
    update-ca-certificates)

# Install the Docker Client
RUN (wget -O /tmp/docker-static.tgz "https://download.docker.com/linux/static/edge/x86_64/docker-17.10.0-ce.tgz" &&\
  cd /tmp &&\
  tar -vxzf docker-static.tgz &&\
  mv /tmp/docker/docker /usr/local/bin/docker &&\
  chmod +x /usr/local/bin/docker &&\
  rm -rf /tmp/docker /tmp/docker-static.tgz)

# install notary
RUN (wget -O /usr/local/bin/notary "https://github.com/docker/notary/releases/download/v0.4.3/notary-Linux-amd64" &&\
  chmod +x /usr/local/bin/notary)

# Add user jenkins to the image
RUN (adduser -D -h /home/jenkins -s /bin/sh -G docker jenkins && \
    addgroup jenkins ping && \
    echo "jenkins:jenkins" | chpasswd && \
    chown -R jenkins:jenkins /home/jenkins/*)
    
# Expose SSH
EXPOSE 22

# Insert a Startup Script and Run it
ADD jenkins-slave-startup.sh /
CMD chmod +x /jenkins-slave-startup.sh && bash /jenkins-slave-startup.sh
