#checkov:skip=CKV_DOCKER_2: Healthcheck not required as container not long lived
#checkov:skip=CKV_DOCKER_3: User not required
FROM ubuntu:20.04

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    curl \
    gnupg \
    jq \
    software-properties-common \
    unzip \
    zip

RUN add-apt-repository ppa:git-core/ppa
RUN add-apt-repository ppa:deadsnakes/ppa

# Git
RUN apt install -y --no-install-recommends \
    git \
    git-lfs \
    git-ftp \
    python3.7 \
    python3-pip

# Terraform 1.1.6
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get install -y terraform=1.1.6

# Terragrunt 0.36.1
RUN curl -s -L "https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.1/terragrunt_linux_amd64" -o /usr/bin/terragrunt && chmod 777 /usr/bin/terragrunt

# Checkov
RUN python3.7 -m pip install -U checkov

# TFLint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

CMD /bin/sh
