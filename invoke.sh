#!/bin/bash

function showHelp() {
    echo "Please run this script as root or sudo"
    echo "sudo $0"
    echo "Alternative:"
    echo "sudo su -"
    echo "$0" 
    echo ""
    echo "Flags:"
    echo "    -v <filename>"
    echo "    print output into specified file"
    exit -1
}

# check if the user running the script has enough root
if [ "$USER" != "root" ]; then
    showHelp
fi

if [ "$1" != "-v" ]; then
    showHelp
fi

if [ [ $# -eq 1 ] ]; then
    showHelp
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

if [ $1 = "-v" ]; then
    # run playbook and log into specified file
    ansible-playbook -i inventory $ymlFile -u ansible --become >> $2 
else
    # run playbook
    ansible-playbook -i inventory $ymlFile -u ansible --become
fi
