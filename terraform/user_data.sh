
#!/bin/bash
set -euxo pipefail

exec > >(tee -a /var/log/mausam-setup.log) 2>&1

apt-get update
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

docker pull "${docker_image}"

docker rm -f mausam || true

docker run -d --name mausam --restart unless-stopped -p 5000:5000 "${docker_image}"