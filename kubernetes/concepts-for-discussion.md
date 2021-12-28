### Orchestration of containers 
* what is it 
* Why k8s is neeed for Orchestration

### k8s primitives
* Master/Worker
* Containers, Pods, Nodes
* etcd,kubeapi,scheduler,kubecontroller,kubelet,kubeproxy

### API Objects, context, kubectl 

### Deployments
* deployments (ReplicaSets, Daemonsets ,statefulsets)
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
- labels are for k8s, and annotations are for humans 
- selector works only on labels (MatchLabel)
### Taints, Tolerations
- taints are for nodes, tolerations are for pods 
### configMaps, secrets
- configMaps are environmet variables but not sensitive ; eg: DATABASE_NAME 
- secrets are environment variables but are sensitive , eg: DB_PASSWORD, ssh_private_key
- base64 is encoding, its not encryption 
- k8s protects secrets, but not configMaps
### NodeAffinity vs Pod Affinity

### Horizontal Pod Autoscaler

### Helm Repository , Charts 
- package manager for k8s 
- help deploy/undeploy/rollback different versions of application 
- helm chart is a group of manifests in a particular folder structure
- just like ansible galaxy , helm also has lot of repos where manifests are stored by community 

### RBAC
- Roles, RoleBinding - both namespace scoped 
- clusterrole, clusterRoleBinding - both cluster scoped 

### Monitoring using Prometheus,Grafana 

### Tools 
- k9s