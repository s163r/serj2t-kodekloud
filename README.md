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

3. Use Ansible for other tasks.
example
```
ansible-playbook ansible/playbooks/bootstrap_nodes.yml -u ansible
```