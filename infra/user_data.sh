#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y curl ca-certificates

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-ipv4)

PUBLIC_DNS=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/public-hostname)

curl -sfL https://get.k3s.io | sh -s - server \
  --tls-san "$PUBLIC_IP" \
  --tls-san "$PUBLIC_DNS"

until systemctl is-active --quiet k3s; do
  sleep 3
done

mkdir -p /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
chown -R ubuntu:ubuntu /home/ubuntu/.kube
chmod 600 /home/ubuntu/.kube/config

echo "k3s is ready" > /home/ubuntu/k3s-ready.txt
