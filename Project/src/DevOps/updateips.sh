frontend=$(terraform output -raw frontend)
monitor=$(terraform output -raw monitor)
echo 'frontend='$frontend
echo 'monitor='$monitor

sed -i '1s/.*/lb          ansible_host='$frontend'  ansible_user=ubuntu ansible_connection=ssh/' hosts
sed -i '2s/.*/monitor     ansible_host='$monitor'   ansible_user=ubuntu ansible_connection=ssh/' hosts
echo "Updated ansible_host parameters with the frontend and monitor IP in hosts file."

sed -i '28s/.*/ansible_ssh_common_args= '\'' -o ProxyCommand="ssh -i keypair'\\/'agisit -W %h:%p -q ubuntu@'$monitor' -o UserKnownHostsFile='\\/'dev'\\/'null -o StrictHostKeyChecking=no"'\''/' hosts
echo "Updated ansible_ssh_common_args parameter with the monitor IP in hosts file."

awk -i inplace '{ if (NR == 21) print "        const endpoint = `http://'$frontend':8090?OP=${document.getElementById(\"OP\").value}&X=${document.getElementById(\"X\").value}&Y=${document.getElementById(\"Y\").value}`;"; else print $0}' ../Calculator/front/index.html
echo "Updated the frontend's index.html file."
