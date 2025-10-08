# install dependencies
apt-get -y install openssh-server python3 ansible python3.12-venv python3-pip

# create and source virtual environment
python3 -m venv .venv
source .venv

# install python requirements
pip install passlib

# create library for ssh-demon
mkdir -p /run/sshd

# fetch repo
git clone https://github.com/ansible-lockdown/UBUNTU24-CIS

# replace host: any to host: localhost
sed 's/hosts: any/hosts: localhost/' -i site.yml

# run playbook
ansible-playbook -i inventory site.yml -u ansible --become