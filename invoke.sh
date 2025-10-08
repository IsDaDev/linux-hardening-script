#!/bin/bash

# check if the user running the script has enough root
if [ "$USER" != "root" ]; then
    echo "Please run this script as root or sudo"
    echo "Use: sudo $0"
    echo "Use: sudo su -; ./$0" 
    exit -1
fi

# install dependencies
apt-get -y install openssh-server python3 ansible python3.12-venv python3-pip

# create and source virtual environment
python3 -m venv .venv

# install python requirements
bash -c "source .venv/bin/activate && pip install passlib"

# create library for ssh-demon
mkdir -p /run/sshd

# fetch repo
git clone https://github.com/ansible-lockdown/UBUNTU24-CIS

ymlFile=UBUNTU24-CIS/site.yml

# replace host: all to host: localhost
sed 's/hosts: all/hosts: localhost/' -i $ymlFile

# run playbook
ansible-playbook -i inventory $ymlFile -u ansible --become