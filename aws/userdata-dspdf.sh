#!/bin/bash
apt update
apt upgrade -y
apt install curl docker.io docker-compose make cmake g++ -y
usermod -aG docker ubuntu
chown root:docker /var/run/docker.sock
chown -R root:docker /var/run/docker
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh > /home/ubuntu/install_nvm.sh
sudo -i -u ubuntu source install_nvm.sh
sudo -u ubuntu -- bash -c 'source /home/ubuntu/.nvm/nvm.sh; nvm install 22.14.0'
ln -s /home/ubuntu/.nvm/versions/node/v22.14.0/bin/npm /usr/local/bin/npm
ln -s /home/ubuntu/.nvm/versions/node/v22.14.0/bin/node /usr/local/bin/node
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt install unzip
unzip awscliv2.zip
sudo ./aws/install
ln -s /usr/local/bin/aws /usr/bin/aws
sudo -i -u ubuntu git config --global credential.helper cache
sudo -u ubuntu -- bash -c 'printf "protocol=https\nhost=github.com\nusername=tamfrost\npassword=<token>\n\n" | git credential approve'
sudo -u ubuntu -- bash -c 'printf "protocol=https\nhost=gitlab.com\nusername=tamfrost\npassword=<token>\n\n" | git credential approve'
sudo -u ubuntu -- bash -c 'echo @dspdf:registry=https://gitlab.com/api/v4/packages/npm/ > ~/.npmrc'
sudo -u ubuntu -- bash -c 'echo //gitlab.com/api/v4/packages/npm/:_authToken=<token> >> ~/.npmrc'
sudo -i -u ubuntu aws codeartifact login --tool npm --domain dspdf --domain-owner 007911779249 --repository tamsin-npm-repo
echo "VOLUME_SWAP=\$(lsblk -o NAME,SIZE | grep 5G | awk \"{print \\\"/dev/\\\" \\\$1}\")" | sudo tee -a /home/ubuntu/initialize.sh
echo "VOLUME_CODE=\$(lsblk -o NAME,SIZE | grep 20G | awk \"{print \\\"/dev/\\\" \\\$1}\")" | sudo tee -a /home/ubuntu/initialize.sh
echo "VOLUME_DOCKER=\$(lsblk -o NAME,SIZE | grep 30G | awk \"{print \\\"/dev/\\\" \\\$1}\")" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mkfs -t ext4 \${VOLUME_SWAP}" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mkdir /swap" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mount \${VOLUME_SWAP} /swap" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo fallocate -l 2G /swap/swapfile" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo chmod 600 /swap/swapfile" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mkswap /swap/swapfile" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo swapon /swap/swapfile" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo swapon --show" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mkfs -t ext4 \${VOLUME_CODE}" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mkfs -t ext4 \${VOLUME_DOCKER}" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mkdir /code" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mkdir /docker" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mount \${VOLUME_CODE} /code" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo mount \${VOLUME_DOCKER} /docker" | sudo tee -a /home/ubuntu/initialize.sh
echo "sudo sudo chown -R ubuntu:ubuntu /code" | sudo tee -a /home/ubuntu/initialize.sh
echo "\${VOLUME_CODE} /swap ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "\${VOLUME_SWAP} /code ext4 defaults 0 0" | sudo tee -a /etc/fstab
echo "\${VOLUME_DOCKER} /docker ext4 defaults 0 0" | sudo tee -a /etc/fstab
sudo -u ubuntu -- bash -c 'echo "\"\\e[A\": history-search-backward" >> ~/.inputrc'
sudo -u ubuntu -- bash -c 'echo "\"\\e[B\": history-search-forward" >> ~/.inputrc'
sudo -u ubuntu -- bash -c 'echo "\"\\e[C\": forward-char" >> ~/.inputrc'
sudo -u ubuntu -- bash -c 'echo "\"\\e[D\": backward-char" >> ~/.inputrc'
sudo -u ubuntu -- bash -c 'echo set bell-style none >> ~/.inputrc'
sudo -u ubuntu -- bash -c 'echo "sudo systemctl stop docker" >> ~/docker_setup.sh'
sudo -u ubuntu -- bash -c 'echo "echo {\\\"data-root\\\": \\\"/docker\\\"} | sudo tee -a /etc/docker/daemon.json" >> ~/docker_setup.sh'
sudo -u ubuntu -- bash -c 'echo "sudo systemctl daemon-reexec" >> ~/docker_setup.sh'
sudo -u ubuntu -- bash -c 'echo "sudo systemctl start docker" >> ~/docker_setup.sh'
sudo -u ubuntu -- bash -c 'echo "docker info | grep \"Docker Root Dir\"" >> ~/docker_setup.sh'