### :camel: command based tasks
---

#### Task1 : wait for the cluster nodes to be ready 
```
kubectl get nodes       # wait till the nodes are ready
kubectl cluster-info
```

#### Task2: Deploy k8s dashboard to view the cluster status 
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.5/aio/deploy/recommended.yaml
cat /tmp/eks-admin-service-account.yaml     # see the yml file to create ServiceAccount
kubectl apply -f /tmp/eks-admin-service-account.yaml

#retrive the authentication token to login to the dashboard
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')

#copy the token

#forward port 10443 on host to 443 of kubernetes-dashboard
kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 10443:443 --address 0.0.0.0 &>/dev/null & 
```
* now access the UI using `Dashboard UI` and give port 10443. 
* change the URL to http://URL/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#!/login
* Paste the `token` copied in earlier step
* click on each tab on the left side of the dashboard and try to visualize the concept of it. Keep referring back to this UI after executing commands with kubectl in upcoming tasks.

#### Task3: Launch a pod using image , check it and delete the pods 
```
kubectl run ncdnginx --image=nginx         # Start a nginx pod
kubectl get pods

kubectl run ncdnginx1 --image=nginx --port=80    #Start nginx1 pod,  and let the container expose port 80
kubectl get pods 

# go to dashboard and see the pods

kubectl delete pod ncdnginx
kubectl get pods 

kubectl delete pod ncdnginx1
kubectl get pods 
```
#### Task4: Create a deployment named ncd-tomcat1 , scaleit up, scaleit down 
```
kubectl create deployment ncd-dep-tomcat1 --image=tomcat
kubectl get pods            # pods related to the deployment will start
kubectl get deployments     # ncd-tomcat1 deployment will be visible 

# go to dashboard and check the deployments 

kubectl scale deployment ncd-dep-tomcat1 --replicas=10  # scale the replicaset side to 10. Run the next command immediately
watch -n .5 kubectl get pods                        # you should see new pods being created

# go to dashboard and check the deployments and no. of replicas for this deployment

kubectl scale deployment ncd-dep-tomcat1 --replicas=5   # scaledown the no.of replicas to 5. run watch command immediately
watch -n .5 kubectl get pods                        # you should see new pods being Terminated

# go to dashboard and check the deployments and no. of replicas for this deployment
``` 
#### Task5:expose this deploymet as a service (type NodePort)
```
kubectl expose deployment ncd-dep-tomcat1 --port=31000 --target-port=8080 --type=NodePort --external-ip=<ip-of-vm>
kubectl get svc   #list the services

# go to dashboard and check under services

```
#### Task6: expose the same deployment as another service also
```
kubectl expose deployment ncd-dep-tomcat1 --name=ncd-svc-tomcat2 --port=32000 --target-port=8080 --type=NodePort --external-ip=<ip-of-vm>
kubectl get svc 
kubectl describe svc ncd-dep-tomcat1      # NodePort type of service
kubectl describe svc ncd-svc-tomcat2      # NodePort type of service for the same deployment

# go to dashboard and check under services

```
#### Task7: access the NodePort port from UI. You should reach tomcat server. Its ok even if its an error page
#### Task8: Lets deploy another deployment using a yaml file. 
```
cat /tmp/hello-application.yml                  # have a quick look at deployment yml file
kubectl apply -f /tmp/hello-application.yml     #yaml file is already copied. Create deployment using yaml

kubectl get deployments       # check all deployments 
kubectl describe deployments hello-world    # describe the newly deployed deployment details


kubectl get replicasets         # get details of all replicasets of deployments 
kubectl describe replicasets    # describe all replica sets 

kubectl expose deployment hello-world --type=NodePort --name=example-service  #Create a Service object that exposes the deployment

kubectl describe services example-service   #Display information about the Service

# go to dashboard and deployments/services

```
#### Task9: Make a note of the NodePort value for the service from above command. Open UI and hit that port

#### Task10: List the pods that are running the Hello World application
```
kubectl get pods --selector="run=load-balancer-example" --output=wide

kubectl delete services example-service   #delete the Service
kubectl delete deployment hello-world     #delete the deployment 
```
---
---
### :rocket: scenario based tasks 
#### scenario1: 
#### scenario2: 
#### scenario3: 
#### scenario4: 
#### scenario5: 


















