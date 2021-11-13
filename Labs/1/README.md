# Lab 1 Report

## Q01

### Vagrantfile:
- (line 5) - Defines the provider as VirtualBox.
- (line 11) - For each plugin that is not installed, install it.
- (line 18) - Defines which version of vagrant it will use to configure the machines.
- (line 20) - Does not automatically add a key pair to the guest.
- (line 21) - Automatically updates vbguest plugin.
- (line 22) - Every time it boots, it doesn't try to update them.
- (line 25) - The management machine properties are defined (Operating System, Memory, #CPUs, etc.).
- (line 54) - The properties of the balancing machine are defined (Operating System, Memory, #CPUs, etc.).
- (line 82) - For each web machine, set its properties (Operating System, Memory, #CPUs, etc.).
- (line 47-50) - The scripts that will run in the provisioning phase are defined.

---

## Q02

### bootstrap.sh:
- When the management machine is first mounted, it is the script that installs tools to manage PPA repositories, installs the GNU Privacy Guard, installs dependencies required by Openstack SDK, and installs Ansible.

### hosts_ip.sh:
- The script configures hostnames for internal network.

### hosts_ssh.sh:
- The script configures the sshd_config file to allow only key-based logins.

---

## Q03

- Ansible starts looking for the `ansible.cfg` file in the directory it's in, so if it's in the `/home/vagrant/tools` directory, it detects the `/home/vagrant/tools/ansible.cfg` file, otherwise it detects the `/etc/ansible/ansible.cfg`.

---

## Q04

- I have uncommented lines (9,10,20,21,28,29) from the inventory.in file and replaced line 82 in Vagrantfile with `(1..4).each do |i|`.

---

## Q05

```sh
vagrant@mgmt:~/tools$ ansible all -m shell -a "uptime"
balancer | CHANGED | rc=0 >>
 10:52:02 up  1:19,  1 user,  load average: 0.00, 0.00, 0.00
web4 | CHANGED | rc=0 >>
 10:52:01 up 22 min,  1 user,  load average: 0.01, 0.01, 0.00
web3 | CHANGED | rc=0 >>
 10:52:00 up 24 min,  1 user,  load average: 0.27, 0.06, 0.02
web1 | CHANGED | rc=0 >>
 10:52:00 up 10 min,  1 user,  load average: 0.04, 0.03, 0.00
web2 | CHANGED | rc=0 >>
 10:52:02 up  1:04,  1 user,  load average: 0.00, 0.00, 0.00
localhost | CHANGED | rc=0 >>
 10:52:02 up  1:21,  1 user,  load average: 0.17, 0.04, 0.01
```

---

## Q06

```sh
vagrant@mgmt:~/tools$ ansible all -m shell -a "uname -a"
web4 | CHANGED | rc=0 >>
Linux web4 5.4.0-88-generic #99-Ubuntu SMP Thu Sep 23 17:29:00 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
balancer | CHANGED | rc=0 >>
Linux balancer 5.4.0-88-generic #99-Ubuntu SMP Thu Sep 23 17:29:00 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
web2 | CHANGED | rc=0 >>
Linux web2 5.4.0-88-generic #99-Ubuntu SMP Thu Sep 23 17:29:00 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
web1 | CHANGED | rc=0 >>
Linux web1 5.4.0-88-generic #99-Ubuntu SMP Thu Sep 23 17:29:00 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
web3 | CHANGED | rc=0 >>
Linux web3 5.4.0-88-generic #99-Ubuntu SMP Thu Sep 23 17:29:00 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
localhost | CHANGED | rc=0 >>
Linux mgmt 5.4.0-88-generic #99-Ubuntu SMP Thu Sep 23 17:29:00 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```

---

## Q07

- What was causing the error was that the file `ntp.conf.j2` in this line `server {{noc_ntpserver}}` where the variable `noc_ntpserver` was being replaced by `server 0.europe.pool.ntp.org`, so the word `server` was being repeated 2 times, I solved the problem by removing the word `server` from the declaration of the variable `noc_ntpserver` of the file `ntp-template.yml`.

---

## Q08

- The second time it was executed, all tasks return ok without changing, as they will not be executed if the desired state is already reached.

---

## Q09

- The web server to which the request was forwarded by the load balancer was changing.

---

## Q10

- As concurrency increases, time per request also increases, because we are making more requests than web servers, the maximum number of concurrency appears reflected in the maximum number of sessions that haproxy detects. No requests were queued or discarded and none failed.
