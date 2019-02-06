#!/usr/bin/env sh

echo "Install Weaveworks Socks Shop"
kubectl apply -f yamls/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/microservices-demo/microservices-demo/master/deploy/kubernetes/complete-demo.yaml