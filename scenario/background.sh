#!/bin/bash

apt-get update -y
apt-get install -y wget unzip

TERRAFORM_VERSION="1.9.7"

wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O /tmp/terraform.zip

rm -f /usr/local/bin/terraform || true
rm -rf ~/terraform || true

unzip -o /tmp/terraform.zip -d /tmp
sudo mv /tmp/terraform /usr/local/bin/