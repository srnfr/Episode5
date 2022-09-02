#!/bin/bash

kubectl create ns naff

echo "**AVANT**"

kubectl get nodes --show-labels -o wide

echo "Labelling only *even* Node with zone=dmz"

I=0
for NODENAME in $(kubectl get nodes -o=custom-columns=:.metadata.name); do
	if [[ "$NODENAME" -ne "" ]]; then
		echo ""
		echo "---"
		echo "NODENAME $I = $NODENAME "
		if [ $(( $I  % 2)) -eq 0 ]; then
			kubectl label node $NODENAME zone="dmz" --overwrite
		fi
		I=$((I+1))
	fi
done

kubectl get nodes --show-labels -o wide

kubectl apply -f deploy-node-aff.yaml -n naff

kubectl wait deployment/nginx-deployment -n naff --for=condition=Available=True --timeout=60s
kubectl get pods -o wide -n naff

echo "---"
echo "Cleanup"
kubectl delete ns naff
for NODENAME in $(kubectl get nodes -o=custom-columns=:.metadata.name); do
        if [[ "$NODENAME" -ne "" ]]; then
                        kubectl label node $NODENAME zone- --overwrite
        fi
done

