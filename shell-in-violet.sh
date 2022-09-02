#!/bin/bash

NS=violet
kubectl run -it --rm debug-$NS-$RANDOM  -n $NS --image=wbitt/network-multitool -- /bin/bash
