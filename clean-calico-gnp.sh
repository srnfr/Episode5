#!/bin/bash


for p in $(calicoctl get gnp --allow-version-mismatch | grep -v NAME); do 
	calicoctl delete gnp $p --allow-version-mismatch;
done
