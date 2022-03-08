#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

apt-get update
apt-get install -y --no-install-recommends \
  curl \
  gnupg \
  jq \
  software-properties-common \
  unzip \
  zip

add-apt-repository ppa:git-core/ppa
add-apt-repository ppa:deadsnakes/ppa

# Git
apt install -y --no-install-recommends \
  git \
  git-lfs \
  git-ftp \

# Python
apt install -y --no-install-recommends \
  python3.7 \
  python3-pip

# Terraform 1.1.6
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
apt-get install -y terraform=1.1.6

# Terragrunt 0.36.1
curl -s -L "https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.1/terragrunt_linux_amd64" -o /usr/bin/terragrunt && chmod 777 /usr/bin/terragrunt

# Checkov
python3.7 -m pip install -U checkov

# TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync
