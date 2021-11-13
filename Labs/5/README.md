# Lab 5 Report

## Q01

```
vagrant@mgmt:~/labs/k8scloudmesh$ terraform init
Initializing modules...
- gcp_gke in gcp_gke
- gcp_k8s in gcp_k8s

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/google...
- Finding latest version of hashicorp/kubernetes...
- Finding hashicorp/helm versions matching "2.3.0"...
- Finding gavinbunney/kubectl versions matching "1.13.0"...
- Installing hashicorp/google v4.0.0...
- Installed hashicorp/google v4.0.0 (signed by HashiCorp)
- Installing hashicorp/kubernetes v2.6.1...
- Installed hashicorp/kubernetes v2.6.1 (signed by HashiCorp)
- Installing hashicorp/helm v2.3.0...
- Installed hashicorp/helm v2.3.0 (signed by HashiCorp)
- Installing gavinbunney/kubectl v1.13.0...
- Installed gavinbunney/kubectl v1.13.0 (self-signed, key ID AD64217B5ADD572F)

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

Installed plugins are: `hashicorp/google`; `hashicorp/kubernetes`; `hashicorp/helm`; `gavinbunney/kubectl`.

---

## Q02

The `k8s-monitoring.tf` configuration file is responsible for deploying monitoring components, namely Prometheus and Grafana.
The `kubectl_file_documents` data resources are created where the yaml documents are defined, whose `manifest` property is iterated in the respective `kubectl_manifest` resources. These resources are responsible for managing the lifecycle of the Kubernetes resources.

---

## Q03

The `k8s-istio.tf` configuration file contains all the resource definitions needed to run an application inside a Kubernetes cluster. It defines two resources `istio_base` which installs the CRDs the istio needs to run and the `istiod` which installs the istio daemon. In both, the `chart` property is defined as a local path to the repository that was downloaded earlier.

---

## Q04

The yaml files that are in the `monitoring` folder are manifest files and are intended to configure and create the necessary resources for Prometheus and Grafana, such as: ServiceAccount and ConfigMap, which are needed to deploy them.

---

## Q05

```
vagrant@mgmt:~/labs/k8scloudmesh$ kubectl get pods -n application
NAME                              READY   STATUS    RESTARTS   AGE
frontend-555584b8c9-jcjxq         2/2     Running   0          7m19s
frontend-555584b8c9-k6zkf         2/2     Running   0          7m19s
frontend-555584b8c9-pxlbx         2/2     Running   0          7m19s
redis-follower-6579bcb987-qhr42   2/2     Running   0          7m19s
redis-follower-6579bcb987-qmc2p   2/2     Running   0          7m19s
redis-leader-769c885c4f-qfs7m     2/2     Running   0          7m19s
```

2 containers per pod were reported due to injection of an istio container.

---

## Q06

```
vagrant@mgmt:~/labs/k8scloudmesh$ kubectl get all -n istio-system
NAME                             READY   STATUS    RESTARTS   AGE
pod/grafana-79bd5c4498-nbkzj     1/1     Running   0          19m
pod/istiod-687f965684-kh9nm      1/1     Running   0          19m
pod/prometheus-9f4947649-6rbs2   2/2     Running   0          19m

NAME                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                                 AGE
service/grafana      LoadBalancer   10.3.247.200   35.187.52.195   3000:31401/TCP                          19m
service/istiod       ClusterIP      10.3.249.199   <none>          15010/TCP,15012/TCP,443/TCP,15014/TCP   19m
service/prometheus   LoadBalancer   10.3.250.2     34.78.113.238   9090:32361/TCP                          20m

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/grafana      1/1     1            1           20m
deployment.apps/istiod       1/1     1            1           19m
deployment.apps/prometheus   1/1     1            1           20m

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/grafana-79bd5c4498     1         1         1       20m
replicaset.apps/istiod-687f965684      1         1         1       19m
replicaset.apps/prometheus-9f4947649   1         1         1       20m

NAME                                         REFERENCE           TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
horizontalpodautoscaler.autoscaling/istiod   Deployment/istiod   1%/80%    1         5         1          19m
```

The pods reported as running are: `pod/grafana-79bd5c4498-nbkzj`; `pod/istiod-687f965684-kh9nm`; `pod/prometheus-9f4947649-6rbs2`.
Yes, the replicasets reported are: `replicaset.apps/grafana-79bd5c4498`; `replicaset.apps/istiod-687f965684`; `replicaset.apps/prometheus-9f4947649`.

---

## Q07

```
vagrant@mgmt:~/labs/k8scloudmesh$ kubectl get service -n istio-system
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                                 AGE
grafana      LoadBalancer   10.3.247.200   35.187.52.195   3000:31401/TCP                          26m
istiod       ClusterIP      10.3.249.199   <none>          15010/TCP,15012/TCP,443/TCP,15014/TCP   26m
prometheus   LoadBalancer   10.3.250.2     34.78.113.238   9090:32361/TCP                          26m
```

The following were reported:
- 2 LoadBalancer services: `grafana`; `prometheus`.
- 1 ClusterIP service: `istiod`.

---

## Q08

In Prometheus we can choose only one metric to build a graph, so after analyzing them (accessing a pod and curling the endpoint `/stats/prometheus`), we choose the metric: `istio_agent_process_cpu_seconds_total`.

Dashboard screenshot:
![screenshot](./assets/Q08_1.png)
![screenshot](./assets/Q08_2.png)

---

## Q09

The metrics that make up the dashboard are:
- vCPU usage.
- Memory footprint for components.
- Number of bytes flowing per second.
- Proxy resources usage.
- Istiod resources usage.

Dashboard screenshot:
![screenshot](./assets/Q09_1.png)
![screenshot](./assets/Q09_2.png)

---

## Q10

The metrics that make up the dashboard are:
- Requests volume and duration.
- Success rate.
- Number of bytes sent and received.

Dashboard screenshot:
![screenshot](./assets/Q10_1.png)
![screenshot](./assets/Q10_2.png)
