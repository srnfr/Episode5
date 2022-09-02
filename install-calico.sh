#!/bin/bash


kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.0/manifests/tigera-operator.yaml

kubectl create -f - <<EOF
kind: Installation
apiVersion: operator.tigera.io/v1
metadata:
  name: default
spec:
  kubernetesProvider: AKS
  cni:
    type: Calico
  calicoNetwork:
    bgp: Disabled
    ipPools:
     - cidr: 10.244.0.0/16
       encapsulation: VXLAN
---
apiVersion: operator.tigera.io/v1
kind: APIServer
metadata:
   name: default
spec: {}
EOF

sleep 10
kubectl rollout restart deployment/coredns -n kube-system
