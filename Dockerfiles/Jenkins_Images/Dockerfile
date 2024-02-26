FROM jenkins/jenkins:lts-jdk11

USER root

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y apt-transport-https \
                       ca-certificates \
                       curl \
                       gnupg2 \
                       software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get install -y nodejs

# Try installing npm explicitly if it's missing
RUN apt-get install -y npm

# Verify Node.js and npm installations
RUN node -v && \
    npm -v

# Update packages and install Python, pip, and awscli
RUN apt-get update && \
    apt-get install -y python3 \
                       python3-pip \
                       python3-venv \
                       awscli \
                       python3-boto3


# Switch back to the jenkins user
USER jenkins
