This repo is a solution for task in KodeKloud 100 Days of DevOps
For use^

1. Clone repo to jump host

```sh
git clone https://github.com/s163r/serj2t-kodekloud.git
```
2. Run script to generate ssh key for use ansible.

```sh
cd serj2t-kodekloud
sudo ./keygen.sh
```

3. Install community.general
```
ansible-galaxy collection install community.general
```

4. Use Ansible for other tasks.
example
```
cd ansible
ansible-playbook playbooks/bootstrap_nodes.yml
```