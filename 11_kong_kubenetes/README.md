
install Kong Gateway with Kubernetes Ingress Controller in DB-less mode

## on Kubernetes native
kubectl create namespace kong


kubectl apply -f https://bit.ly/kong-ingress-dbless
kubectl get pods -n kong
kubectl get svc -n kong
kubectl get deployment -n kong

kubectl port-forward deployment/ingress-kong -n kong 8443:443

kubectl delete -f https://bit.ly/kong-ingress-dbless

# Minikube

Open Dashboard with URL
If you don't want to open a web browser, run the dashboard command with the --url flag to emit a URL:
```
minikube dashboard --url
```

## Create a Deployment
Use the kubectl create command to create a Deployment that manages a Pod. The Pod runs a Container based on the provided Docker image.
```
kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
```
View the Deployment:
```
kubectl get deployments
```
View the Pod:
```
kubectl get pods
```
View cluster events:
```
kubectl get events
```
View the kubectl configuration:
```
kubectl config view
```

## Create a Service
Expose the Pod to the public internet using the kubectl expose command:
```
kubectl expose deployment hello-node --type=LoadBalancer --port=8080
```

View the Service you created:
```
kubectl get services
```
The output is similar to:
```
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.108.144.78   <pending>     8080:30369/TCP   21s
kubernetes   ClusterIP      10.96.0.1       <none>        443/TCP          23m
```
On cloud providers that support load balancers, an external IP address would be provisioned to access the Service. On minikube, the LoadBalancer type makes the Service accessible through the minikube service command.

Run the following command:
```
minikube service hello-node
minikube service hello-node --url
```
> There is also a --url option for printing the url of the service which is what gets opened in the browser:

> https://minikube.sigs.k8s.io/docs/handbook/accessing/

Sol1
```
//Forward port 
kubectl port-forward deployment/hello-node 8080:8080
curl http://localhost:8080
```
Sol2
Create a Service object that exposes the deployment:
```
kubectl delete service hello-node
kubectl expose deployment hello-node --type=NodePort --port=8080
kubectl get service -A
//Display information about the Service:
kubectl describe services hello-node
//curl http://<public-node-ip>:<node-port>
minikube ip
curl http//172.27.56.159:32034
```




## Clean up
Now you can clean up the resources you created in your cluster:
```
kubectl delete service hello-node
kubectl delete deployment hello-node
```

Optionally, stop the Minikube virtual machine (VM):
```
minikube stop
```
Optionally, delete the Minikube VM:
```
minikube delete
```