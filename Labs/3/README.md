# Lab 3 Report

## Q01

```
vagrant@mgmt:~/labs/gcpcloud$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/google...
- Installing hashicorp/google v3.89.0...
- Installed hashicorp/google v3.89.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

---

## Q02

In this configuration file, a set of resources is declared:
- It declares 3 identical VM instances taking the web server role and 1 instance taking the load balancer role. For web servers and load balancer, it defines the OS image, network, machine type, zone and add a public key to be able to use Ansible over SSH.

---

## Q03

The file specifies a collection of variables that define certain attributes and can be accessed from other files. ​​Defined variables are the project name, machine type, region and disk size.

---

## Q04

Change the `count` value from line 10 in the `terraform-gcp-servers.tf` file.

---

## Q05

After running the apply command, the `terraform.tfstate` file was created.

---

## Q06

It was necessary to fill in the IPs of the balancing machine, web1, web2 and web3.

---

## Q07

```
vagrant@mgmt:~/labs/gcpcloud$ ansible targets -m ping
web2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
balancer | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web3 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

Access to the machines was allowed because when Terraform created the instances, it associated a key pair whose private key our management node has. And access to machines is done via SSH.

---

## Q08

I had to make the following changes to the files:

### Terraform

`terraform-gcp-variables.tf`:
- Line 7:
    - [-] `agisit-2021-webservice`
    - [+] `agisit-2021-lab3-g12t-330207`
- Line 24:
    - [-] `europe-west3-c`
    - [+] `europe-west3-a`

`terraform-gcp-servers.tf`:
- Line 19 & 46:
    - [-] `ubuntu-1804-bionic-v20201116`
    - [+] `ubuntu-2004-focal-v20210927`

`terraform-gcp-provider.tf`:
- Line 9:
    - [-] `agisit-2021-webservice-ec16b8b078c2.json`
    - [+] `agisit-2021-lab3-g12t-330207-fd8c267c6a9e.json`

`terraform-gcp-networks.tf`:
- Line 17:
    - [-] `target_tags = ["balancer"]`
    - [+] `target_tags = ["balancer", "web"]`

### Ansible

`haproxy.cfg.j2`:
- Line 56:
    - [-] `hostvars[host]['ansible_default_ipv4']['address']`
    - [+] `hostvars[host]['ansible_host']`

`index.html.j2`:
- Line 19:
    - [-] `ansible_default_ipv4.address`
    - [+] `hostvars[ansible_hostname]['ansible_host']`

`ansible.cfg`:
- Line 5:
    - [-] `/home/vagrant/gcpcloud-tenant/gcphosts`
    - [+] `/home/vagrant/labs/gcpcloud/gcphosts`

`ansible-load-credentials.sh`:
- Line 2:
    - [-] `./agisit-2021-webservice-ec16b8b078c2.json`
    - [+] `./agisit-2021-lab3-g12t-330207-fd8c267c6a9e.json`

`ansible-gcp-servers-setup-all.yml`:
- Line 59:
    - [-] `/home/vagrant/gcpcloud-tenant/templates/index.html.j2`
    - [+] `/home/vagrant/labs/gcpcloud/templates/index.html.j2`
- Line 91 & 93:
    - [-] `hostvars[item]['ansible_default_ipv4']['address']`
    - [+] `hostvars[item]['ansible_host']`
- Line 116:
    - [-] `/home/vagrant/gcpcloud-tenant/templates/haproxy.cfg.j2`
    - [+] `/home/vagrant/labs/gcpcloud/templates/haproxy.cfg.j2`

---

## Q09

The web server to which the request is forwarded changes. The IPs shown are the IPs corresponding to the web servers that are responding to the request.

---

## Q10

Result:
```
google_compute_instance.web[2]: Destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web3]
google_compute_instance.balancer: Destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/balancer]
google_compute_firewall.balancer_rules: Destroying... [id=projects/agisit-2021-lab3-g12t-330207/global/firewalls/balancer]
google_compute_instance.web[0]: Destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web1]
google_compute_firewall.frontend_rules: Destroying... [id=projects/agisit-2021-lab3-g12t-330207/global/firewalls/frontend]
google_compute_instance.web[1]: Destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web2]
google_compute_instance.web[2]: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web3, 10s elapsed]
google_compute_instance.balancer: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/balancer, 10s elapsed]
google_compute_instance.web[0]: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web1, 10s elapsed]
google_compute_instance.web[1]: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web2, 10s elapsed]
google_compute_firewall.balancer_rules: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/global/firewalls/balancer, 10s elapsed]
google_compute_firewall.frontend_rules: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/global/firewalls/frontend, 10s elapsed]
google_compute_firewall.frontend_rules: Destruction complete after 11s
google_compute_firewall.balancer_rules: Destruction complete after 12s
google_compute_instance.web[2]: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web3, 20s elapsed]
google_compute_instance.balancer: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/balancer, 20s elapsed]
google_compute_instance.web[1]: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web2, 20s elapsed]
google_compute_instance.web[0]: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/web1, 20s elapsed]
google_compute_instance.web[2]: Destruction complete after 22s
google_compute_instance.web[1]: Destruction complete after 22s
google_compute_instance.web[0]: Destruction complete after 22s
google_compute_instance.balancer: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/balancer, 30s elapsed]
google_compute_instance.balancer: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/balancer, 40s elapsed]
google_compute_instance.balancer: Still destroying... [id=projects/agisit-2021-lab3-g12t-330207/zones/europe-west3-a/instances/balancer, 50s elapsed]
google_compute_instance.balancer: Destruction complete after 53s

Destroy complete! Resources: 6 destroyed.
```

All resources created have been destroyed. In the ACTIVITY tab of the panel the logs of which resources are being destroyed are displayed.
