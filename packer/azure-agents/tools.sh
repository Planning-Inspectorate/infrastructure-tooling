#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

sudo echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  curl \
  gnupg \
  jq \
  software-properties-common \
  unzip \
  zip

sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:deadsnakes/ppa

# Git
sudo apt install -y --no-install-recommends \
  git \
  git-lfs \
  git-ftp \

# Python
sudo apt install -y --no-install-recommends \
  python3.7 \
  python3-pip

# Terraform 1.1.6
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get install -y terraform=1.1.6

# Terragrunt 0.36.1
sudo curl -s -L "https://github.com/gruntwork-io/terragrunt/releases/download/v0.36.1/terragrunt_linux_amd64" -o /usr/bin/terragrunt && chmod 777 /usr/bin/terragrunt

# Checkov
python3.7 -m pip install -U checkov

# TFLint
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync
