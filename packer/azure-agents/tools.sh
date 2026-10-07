export DEBIAN_FRONTEND=noninteractive

sudo echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
sudo echo 'APT::Acquire::Retries "3";' > /etc/apt/apt.conf.d/80-retries
sudo echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

sudo add-apt-repository main
sudo add-apt-repository restricted
sudo add-apt-repository universe
sudo add-apt-repository multiverse
sudo add-apt-repository ppa:git-core/ppa
sudo add-apt-repository ppa:deadsnakes/ppa

sudo apt-get clean && apt-get update && apt-get upgrade
sudo apt-get install -y --no-install-recommends \
  build-essential \
  ca-certificates \
  curl \
  gnupg \
  jq \
  libasound2 \
  libbz2-dev \
  libffi-dev \
  libgbm-dev \
  libgconf-2-4 \
  libgtk2.0-0 \
  libgtk-3-0 \
  liblzma-dev \
  libnotify-dev \
  libnss3 \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libxss1 \
  libxtst6 \
  lsb-release \
  software-properties-common \
  unzip \
  xauth \
  xvfb \
  xz-utils \
  zip \
  zlib1g-dev

# Git
sudo apt-get install -y --no-install-recommends \
  git \
  git-lfs \
  git-ftp

# Python(Ubuntu 22 uses 3.10 by default)
sudo apt-get install -y --no-install-recommends \
  python3 \
  python3-distutils \
  python3-pip

## Install Chromium for test images
# Add the Google Chrome signing key
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -

# Add the Google Chrome repository
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Update the package list and install Google Chrome
sudo apt-get update
sudo apt-get install -y google-chrome-stable

# Setup apt for Docker BuildKit (official Docker repo)
# Add Docker's official GPG key:
sudo apt update
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

# Install Docker BuildKit
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Configure Docker daemon to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
sudo systemctl status docker

# Powershell
sudo snap install powershell --classic

## Azure PowerShell Modules (Az) - used for key vault and app reg scanning
pwsh -Command "Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted"
pwsh -Command "Install-Module -Name Az -RequiredVersion 16.0.0 -Force -AllowClobber -Scope AllUsers -Repository PSGallery"

# Terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get install -y terraform=1.16.5-1 # the hyphen is needed for the repo

# Terragrunt 0.55.1
sudo curl -s -L "https://github.com/gruntwork-io/terragrunt/releases/download/v0.55.1/terragrunt_linux_amd64" -o /usr/bin/terragrunt && chmod 777 /usr/bin/terragrunt

# Checkov
python3 -m pip install --force-reinstall packaging==21
python3 -m pip install -U checkov==3.2.405

# TFLint
curl -sSLO https://github.com/terraform-linters/tflint/releases/latest/download/tflint_linux_amd64.zip
unzip tflint_linux_amd64.zip
sudo install -c -v tflint /usr/local/bin/
rm tflint_linux_amd64.zip

# NVM
sudo mkdir /usr/local/nvm && chmod -R 777 /usr/local/nvm
sudo curl -o- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | NVM_DIR=/usr/local/nvm bash

export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PATH="$PATH:$NVM_DIR"

sudo tee /etc/skel/.bashrc > /dev/null <<"EOT"
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export PATH="$PATH:$NVM_DIR"
EOT

# Node versions
nvm install 24
nvm install 22
nvm install 20

nvm alias default 22
nvm use default

# Install pyenv using the official git-clone method from the pyenv docs.
if [ ! -d /opt/pyenv ]; then
  sudo git clone https://github.com/pyenv/pyenv.git /opt/pyenv
else
  sudo git -C /opt/pyenv pull --ff-only
fi

# Make pyenv available in the current shell session.
export PYENV_ROOT="/opt/pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init - bash)"

# Make pyenv available to all future bash shells on the image.
sudo tee -a /etc/skel/.bashrc > /dev/null <<'EOT'
export PYENV_ROOT="/opt/pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
eval "$(pyenv init - bash)"
EOT

# Python versions
pyenv install 3.11
pyenv install 3.12
pyenv install 3.13
pyenv install 3.14
pyenv global 3.14

# pyenv ADO support
pyenv rehash
sudo chmod 777 "$PYENV_ROOT/shims"

# Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

sudo apt-get update; \
  sudo apt-get install -y apt-transport-https

## Keep waagent on the system Python used by walinuxagent
sudo apt-get install -y walinuxagent

# Deprovision for image capture
sudo env -i \
  HOME="$HOME" \
  PATH="/usr/sbin:/usr/bin:/sbin:/bin" \
  /usr/sbin/waagent -force -deprovision+user

export HISTSIZE=0
sync
