#!/bin/bash

NS=default
##IMG="gcr.io/google-containers/busybox"
##IMG="curlimages/curl"
IMG=nicolaka/netshoot

for NODENAME in $(kubectl get nodes -o=custom-columns=:.metadata.name); do
	if [[ ! -z "{$NODENAME// }" ]]; then
		echo ""
		echo "---"
		echo "NODENAME = $NODENAME "
		kubectl run p$RANDOM -n $NS -q -it --rm --image=$IMG --overrides='{"apiVersion": "v1", "spec": {"nodeName": "'$NODENAME'"}}' -- curl -sk https://myip.sreytan.workers.dev
	fi
done
