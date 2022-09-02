#!/bin/bash

NS=blue

kubectl run -it --rm debug-$NS-$RANDOM  -n $NS --image=wbitt/network-multitool -- /bin/bash
