cd DevOps
terraform init
terraform apply -auto-approve
sh updateips.sh
chmod 600 keypair/agisit
ansible-galaxy install cloudalchemy.grafana
ansible-galaxy install cloudalchemy.prometheus
ansible-playbook ansible-servers-setup-all.yml
bash runTests.bash
