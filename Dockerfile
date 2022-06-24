FROM asclepius:base
RUN apt-get update
COPY pass.yml /etc/ansible/pass.yml
COPY hosts /etc/ansible/hosts
COPY ansible.cfg /etc/ansible/ansible.cfg
COPY main.yml /etc/ansible/playbooks/main.yml
COPY ./roles/. /etc/ansible/roles/