#!/bin/bash
set -euxo pipefail

apt-get update -y
apt-get install -y curl ca-certificates

curl -sfL https://get.k3s.io | sh -

until systemctl is-active --quiet k3s; do
  sleep 3
done

mkdir -p /home/ubuntu/.kube
cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
chown -R ubuntu:ubuntu /home/ubuntu/.kube
chmod 600 /home/ubuntu/.kube/config

echo "k3s is ready" > /home/ubuntu/k3s-ready.txt
