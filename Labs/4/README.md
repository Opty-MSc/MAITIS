# Lab 4 Report

## Q01

```
vagrant@mgmt:~/labs/k8scloud$ terraform init

Initializing modules...
- gcp_gke in gcp_gke
- gcp_k8s in gcp_k8s

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/google...
- Finding latest version of hashicorp/kubernetes...
- Installing hashicorp/google v3.90.0...
- Installed hashicorp/google v3.90.0 (signed by HashiCorp)
- Installing hashicorp/kubernetes v2.6.1...
- Installed hashicorp/kubernetes v2.6.1 (signed by HashiCorp)

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

Installed plugins are: `hashicorp/google`; `hashicorp/kubernetes`.

---

## Q02

The `terraform.tfvars` file defines project configuration variables that are used by other terraform files. The defined variables are:
- `project`: Project id;
- `workers_count`: Number of worker nodes that will run the containers;
- `region`: Region where instances are created in the cloud.

---

## Q03

Declare the variables defined in the `terraform.tfvars` file and in the following modules:
- `gcp_gke`: Contains the Kubernetes cluster definition;
- `gcp_k8s`: Contains the definition of pods and services.

---

## Q04

I would like to change in the `k8s-pods.tf` file in the resource definition specification the number of replicas. And, consequently, perhaps increase the number of worker nodes in the `terraform.tfvars` file accordingly.

---

## Q05

Yes, there were the following errors:

```
│ Error: googleapi: Error 403: 
│     (1) insufficient regional quota to satisfy request: resource "CPUS": request requires '30.0' and is short '6.0'. project has a quota of '24.0' with '24.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=agisit-2021-kub-g12t
│     (2) insufficient regional quota to satisfy request: resource "IN_USE_ADDRESSES": request requires '15.0' and is short '7.0'. project has a quota of '8.0' with '8.0' available. View and manage quotas at https://console.cloud.google.com/iam-admin/quotas?usage=USED&project=agisit-2021-kub-g12t., forbidden
│ 
│   with module.gcp_gke.google_container_cluster.guestbook,
│   on gcp_gke/gcp-gke-cluster.tf line 18, in resource "google_container_cluster" "guestbook":
│   18: resource "google_container_cluster" "guestbook" {
```

To solve the error, 2 requests were made in the Google Cloud Platform (GCP) to increase the quota available in the following parameters:
- Requested 6 more CPUs. From 24 to 30.
- Requested 7 more IPs. From 8 to 15.

---

## Q06

The new files that appeared were:
- `terraform.tfstate`
- `terraform.tfstate.backup`

---

## Q07

In the `k8s-provider.tf` file, the following variables are defined: `client_certificate`, `client_key` and `cluster_ca_certificate`. The values of these variables are obtained from the `gcp-gke-main.tf` file. Which in turn are taken as output from the `gcp_gke` module. They are used to be able to authenticate with GCP and with the cluster, without using username/password.

---

## Q08

The order of the declarations is not relevant, we tried with a different order and there was no problem.

---

## Q09

- `frontend`: 34.141.108.172
- `redis-follower`: 10.123.243.244	
- `redis-leader`: 10.123.242.29

---

## Q10

```
vagrant@mgmt:~/labs/k8scloud$ kubectl get pods
NAME                              READY   STATUS    RESTARTS   AGE
frontend-555584b8c9-6kqvc         1/1     Running   0          16m
frontend-555584b8c9-v7dnh         1/1     Running   0          16m
frontend-555584b8c9-xh27b         1/1     Running   0          16m
redis-follower-6579bcb987-fdmcd   1/1     Running   0          16m
redis-follower-6579bcb987-wb4kd   1/1     Running   0          16m
redis-leader-769c885c4f-szlcg     1/1     Running   0          16m
```

```
vagrant@mgmt:~/labs/k8scloud$ kubectl get service
NAME             TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)        AGE
frontend         LoadBalancer   10.123.243.135   34.141.108.172   80:30635/TCP   17m
kubernetes       ClusterIP      10.123.240.1     <none>           443/TCP        18m
redis-follower   ClusterIP      10.123.243.244   <none>           6379/TCP       17m
redis-leader     ClusterIP      10.123.242.29    <none>           6379/TCP       17m
```

```
vagrant@mgmt:~/labs/k8scloud$ gcloud container clusters describe guestbook --region europe-west1 --format='default(locations)'
locations:
- europe-west1-b
- europe-west1-c
- europe-west1-d
```

The command is intended to show that clusters are spread across different zones of a region, this allows the system to provide high availability.
