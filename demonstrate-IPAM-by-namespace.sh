#!/bin/bash

kubectl create ns ipamtest
kubectl delete -f IPPools.yaml
kubectl get IPPools

echo "---"
echo "BEFORE"
echo "---"

kubectl create deployment before --image=nginx -n ipamtest --replicas=3
kubectl wait deployment/before -nipamtest --for=condition=Available=True --timeout=30s

kubectl get pods -o wide -n ipamtest
kubectl describe ns/ipamtest

##exit

echo "---"
echo "AFTER ANNOTATION TO THE NAMESPACE"
echo "---"
kubectl apply -f IPPools.yaml
echo "We attach an annotation to ipmatest namespace"
kubectl annotate namespace ipamtest cni.projectcalico.org/ipv4pools='["243-pool"]'

kubectl describe ns/ipamtest 
kubectl create deployment after --image=nginx --replicas=3 -n ipamtest
kubectl wait deployment/after -n ipamtest --for=condition=Available=True --timeout=60s
kubectl get pods -o wide -n ipamtest

echo "---"
echo "AFTER ANNOTATION A POD"
echo "---"
kubectl apply -f special-pod-w-annotation.yaml -n ipamtest
kubectl wait pod/pod-242 -n ipamtest --for=condition=Ready --timeout=60s
kubectl get pods -o wide -n ipamtest


kubectl delete deployment/before -n ipamtest
kubectl delete deployment/after -n ipamtest
kubectl delete pod/pod-242 -n ipamtest
kubectl delete ns ipamtest
