### Orchestration of containers 
* what is it 
* Why k8s is neeed for Orchestration

### k8s primitives
* Master/Worker
* Containers, Pods, Nodes
* etcd,kubeapi,scheduler,kubecontroller,kubelet,kubeproxy

### API Objects, context, kubectl 

### Deployments
* deployments (ReplicaSets, Daemonsets)
* Services
    + ClusterIP
    + NodePort
    + LoadBalancer
* Ingress Vs Ingress Controller

### volumes
- ephemeral volumes Vs persistant volumes
- ephemeral
    - emptyDir{} 
- persistant
    - hostpath (not suitable or multinode cluster)
    - static volumes created on nfs or other storage 
    - dynamic volumes created on nfs or other storage , using storageClass 
        - provisioner in storageClass
- Persistance Volume, Persistance Volume Claim

### labels, Annotatons , Selectors
### Taints, Tolerations

### configMaps, secrets

### NodeAffinity vs Pod Affinity 

### Horizontal Pod Autoscaler

### Helm Repository , Charts 

### RBAC

### Monitoring using Prometheus,Grafana 

### Tools 
- k9s