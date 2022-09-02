#!/bin/bash

az aks get-credentials --resource-group training-demo-srn --name k8s-az --overwrite-existing

kubectl get nodes
