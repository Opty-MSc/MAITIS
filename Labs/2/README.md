# Lab 2 Report

## Q01

```
vagrant@mgmt:~/labs/vmcloud$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of terraform-provider-openstack/openstack...
- Finding latest version of hashicorp/random...
- Installing terraform-provider-openstack/openstack v1.44.0...
- Installed terraform-provider-openstack/openstack v1.44.0 (self-signed, key ID 4F80527A391BEFD2)
- Installing hashicorp/random v3.1.0...
- Installed hashicorp/random v3.1.0 (signed by HashiCorp)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

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
- Declare a randomly generated alphanumeric string with 4 characters, containing no capital letters or special characters.
- Declare a key pair within the open stack with the random string defined above and the associated public key pre-generated.
- It declares 3 VM instances, 2 web and 1 load balancer, inside the open stack where are defined its name, image, flavor, key pair, security groups and the network it is a part of.

---

## Q03

It declares the security group which is used in instances within the open stack where its name, description and 2 rules that allow traffic on ports 80 and 443 with source anywhere are defined.

---

## Q04

Change the `count` value from line 27 in the `terraform-vmcloud-servers.tf` file.

---

## Q05

After running the apply command, the `terraform.tfstate` file was created.

---

## Q06

It was necessary to fill in the IPs of the balancing machine, web1 and web2 and comment on the occurrences of web3.

---

## Q07

```
vagrant@mgmt:~/labs/vmcloud$ ansible targets -m ping
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
```

Access to the machines was allowed because when Terraform created the instances, it associated a key pair whose private key our management node has. And access to machines is done via SSH.

---

## Q08

I had to make the following changes to the files:

`haproxy.cfg.j2`:
- [-] `hostvars[host]['ansible_facts']['ansible_default_ipv4.interface']['ipv4']['address']`
- [+] `hostvars[host]['ansible_host']`

`index.html.j2`:
- [-] `hostvars[ansible_hostname][ansible_facts][ansible_default_ipv4.interface].ipv4.address`
- [+] `hostvars[ansible_hostname]['ansible_host']`

`default-site.j2`:
- [-] `listen 443 ssl;`

---

## Q09

The web server to which the request is forwarded changes.

---

## Q10

Result:
```
openstack_compute_instance_v2.balancer: Destroying... [id=498a421e-3146-4e99-8960-0443d533a1ba]
openstack_compute_instance_v2.web[1]: Destroying... [id=e6950c41-7e8b-41dd-b3f2-fc4b01358575]
openstack_compute_instance_v2.web[0]: Destroying... [id=8b8ee7cb-b66c-400b-b8f4-83bc74c5cd4a]
openstack_compute_instance_v2.balancer: Still destroying... [id=498a421e-3146-4e99-8960-0443d533a1ba, 10s elapsed]
openstack_compute_instance_v2.web[0]: Still destroying... [id=8b8ee7cb-b66c-400b-b8f4-83bc74c5cd4a, 10s elapsed]
openstack_compute_instance_v2.web[1]: Still destroying... [id=e6950c41-7e8b-41dd-b3f2-fc4b01358575, 10s elapsed]
openstack_compute_instance_v2.balancer: Destruction complete after 12s
openstack_compute_instance_v2.web[0]: Destruction complete after 12s
openstack_compute_instance_v2.web[1]: Destruction complete after 12s
openstack_compute_secgroup_v2.sec_ingr: Destroying... [id=658b808b-339c-4f00-b969-0181a1b897ff]
openstack_compute_keypair_v2.keypair: Destroying... [id=676g]
openstack_compute_keypair_v2.keypair: Destruction complete after 1s
random_string.random_name: Destroying... [id=676g]
random_string.random_name: Destruction complete after 0s
openstack_compute_secgroup_v2.sec_ingr: Destruction complete after 2s
```

All resources created in vmcloud have been destroyed. However, the resources that were already there remained there.
