FROM ubuntu:20.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    jq=1.6-1ubuntu0.20.04.1 \
    software-properties-common

RUN add-apt-repository ppa:git-core/ppa
RUN apt-get install -y --no-install-recommends \
    git \
    git-lfs \
    git-ftp

# node
ENV NODE_VERSION 16.14.0
ENV NVM_DIR /usr/local/nvm
RUN mkdir -p $NVM_DIR && \
    curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.39.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/v$NODE_VERSION/bin:$PATH

# Terraform 1.1.6
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get install -y terraform=1.1.6

# Terragrunt 0.36.1
RUN curl -s -L "https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.1/terragrunt_linux_amd64" -o /usr/bin/terragrunt && chmod 777 /usr/bin/terragrunt

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

CMD /bin/sh
