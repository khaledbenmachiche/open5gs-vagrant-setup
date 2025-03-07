#!/bin/bash
apt-get update -y
apt-get install -y gnupg wget tcpdump make gcc g++ libsctp-dev lksctp-tools iproute2 software-properties-common
snap install cmake --classic
cd /home/vagrant/UERANSIM
if [ -d "UERANSIM" ]; then
    echo "Le répertoire UERANSIM existe déjà, suppression de .git pour une nouvelle configuration..."
    rm -rf UERANSIM/.git
else
    echo "Clonage du dépôt UERANSIM..."
    git clone https://github.com/aligungr/UERANSIM.git
fi
cd UERANSIM
git init
git remote add origin https://github.com/aligungr/UERANSIM
git fetch
git reset --hard origin/master
echo "Compilation de UERANSIM..."
make
echo "Installation terminée avec succès !"