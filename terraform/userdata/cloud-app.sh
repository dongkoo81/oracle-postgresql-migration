#!/bin/bash
set -e

# Set hostname
hostnamectl set-hostname cloud-app
echo "127.0.0.1 cloud-app" >> /etc/hosts

# Random delay to avoid simultaneous package downloads (0-30 seconds)
RANDOM_DELAY=$((RANDOM % 31))
echo "Waiting ${RANDOM_DELAY} seconds to avoid package manager conflicts..."
sleep $RANDOM_DELAY

# Wait for any existing dnf/yum processes and locks
while fuser /var/lib/rpm/.rpm.lock >/dev/null 2>&1 || pgrep -x dnf > /dev/null || pgrep -x yum > /dev/null; do
  echo "Waiting for package manager to be available..."
  sleep 5
done

# Clean dnf cache to avoid corruption
dnf clean all

# Update system
dnf update -y

# Install git
dnf install -y git

# Install Java 17 (for Spring Boot) with retry
for i in {1..3}; do
  if dnf install -y java-17-amazon-corretto-devel; then
    break
  else
    echo "Java installation attempt $i failed, retrying..."
    dnf clean all
    sleep 10
  fi
done

# Install PostgreSQL client
dnf install -y postgresql16

# Clone project repository
mkdir -p /home/ec2-user/projects
cd /home/ec2-user/projects
git clone https://github.com/dongkoo81/oracle-postgresql-migration.git

# Set ownership
chown -R ec2-user:ec2-user /home/ec2-user/projects

# Verify installations
git --version
java -version
psql --version

echo "Installation completed successfully!"
echo "Project cloned to: /home/ec2-user/projects/oracle-postgresql-migration"
