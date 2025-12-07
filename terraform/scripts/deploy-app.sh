#!/bin/bash
set -e

echo "=== Starting Application Deployment ==="

# Install git if not installed
if ! command -v git &> /dev/null; then
    echo "Installing git..."
    sudo dnf install -y git
fi

# Install Java if not installed
if ! command -v java &> /dev/null; then
    echo "Installing Java 17..."
    sudo dnf install -y java-17-amazon-corretto-devel
fi

# Clone repository
echo "Cloning repository..."
sudo mkdir -p /home/ec2-user/projects
cd /home/ec2-user/projects

if [ -d "oracle-postgresql-migration" ]; then
    echo "Repository already exists, pulling latest..."
    cd oracle-postgresql-migration
    sudo git pull
else
    echo "Cloning fresh repository..."
    sudo git clone https://github.com/dongkoo81/oracle-postgresql-migration.git
    cd oracle-postgresql-migration
fi

# Set ownership
sudo chown -R ec2-user:ec2-user /home/ec2-user/projects

echo "=== Deployment Complete ==="
echo "Repository location: /home/ec2-user/projects/oracle-postgresql-migration"
ls -la /home/ec2-user/projects/oracle-postgresql-migration
