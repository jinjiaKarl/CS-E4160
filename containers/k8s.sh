minikube start
eval $(minikube -p minikube docker-env)
minikube tunnel
k apply -f sa-frontend-pod.yaml 
sudo kubectl port-forward sa-frontend 88:80 # can't use 88, so use 8080
kubectl apply -f sa-frontend-pod2.yaml
kubectl apply -f service-sa-frontend-lb.yaml
kubectl get svc
kubectl delete po sa-frontend sa-frontend2
kubectl apply -f sa-frontend-deployment.yaml


k apply -f sa-logic-deployment.yaml
k apply -f service-sa-logic.yaml

k apply -f sa-web-app-deployment.yaml
k apply -f service-sa-web-app-lb.yaml



k delete -f sa-frontend-deployment.yaml
k delete -f service-sa-frontend-lb.yaml


k delete -f sa-logic-deployment.yaml
k delete -f service-sa-logic.yaml

k delete -f sa-web-app-deployment.yaml
k delete -f service-sa-web-app-lb.yaml
