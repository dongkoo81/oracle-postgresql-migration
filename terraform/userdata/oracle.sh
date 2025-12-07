#!/bin/bash
set -e

# Set hostname
hostnamectl set-hostname onprem-oracle-ee-19c
echo "127.0.0.1 onprem-oracle-ee-19c" >> /etc/hosts

# Install SSM Agent for RHEL
dnf install -y https://s3.ap-northeast-2.amazonaws.com/amazon-ssm-ap-northeast-2/latest/linux_amd64/amazon-ssm-agent.rpm

# Start and enable SSM Agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

echo "SSM Agent installed and started"
