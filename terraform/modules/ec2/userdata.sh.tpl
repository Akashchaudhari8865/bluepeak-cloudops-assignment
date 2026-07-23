#!/bin/bash
set -euxo pipefail

exec > >(tee /var/log/user-data.log)
exec 2>&1

dnf update -y

dnf install -y docker unzip awscli

systemctl enable docker
systemctl start docker

mkdir -p /opt/${app_name}

cd /opt/${app_name}

echo "Downloading application..."

aws s3 cp s3://${artifact_bucket}/${artifact_object_key} application.zip

echo "Unzipping..."

unzip -o application.zip

echo "Building Docker image..."

docker build -t ${app_name}:latest .

docker rm -f ${app_name} || true

echo "Starting container..."

docker run -d \
  --name ${app_name} \
  --restart unless-stopped \
  -p 80:80 \
  ${app_name}:latest

echo "Deployment completed."