#!/bin/bash
APT_REPOSITORIES=(
  "main"
  "restricted"
  "universe"
  "multiverse"
)

COMMON_PACKAGES=(
  "build-essential"
  "jq"
  "unzip"
  "xvfb"
  "python3-pip"
)

DOCKER_COMPOSE_VERSION="1.29.2"

TFENV_VERSION="3.0.0"

TERRAFORM_VERSIONS=("1.7.3" "1.9.0")
DEFAULT_TERRAFORM_VERSION="1.9.0"

TERRAGRUNT_VERSION="0.55.1"

CHECKOV_VERSION="2.2.94"

NODE_VERSIONS=("20" "18" "16" "15" "14")
DEFAULT_NODE_VERSION="16"
