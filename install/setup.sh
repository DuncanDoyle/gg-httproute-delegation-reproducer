#!/bin/sh

pushd ..

# Deploy the Gateways

#K8S Gateway API
kubectl create namespace ingress-gw --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f gateways/gw.yaml

# Create namespaces if they do not yet exist
kubectl create namespace httpbin --dry-run=client -o yaml | kubectl apply -f -

# Label the default namespace, so the gateway will accept the HTTPRoute from that namespace.
printf "\nLabel default namespace ...\n"
kubectl label namespaces default --overwrite shared-gateway-access="true"

# Deploy the HTTPBin application
printf "\nDeploy HTTPBin application ...\n"
kubectl apply -f apis/httpbin.yaml

# Reference Grants
printf "\nDeploy Reference Grants ...\n"
kubectl apply -f referencegrants/httpbin-ns/default-ns-httproute-service-rg.yaml

# HTTPRoutes
printf "\nDeploy HTTPRoutes ...\n"
kubectl apply -f routes/httpbin-httproute.yaml
kubectl apply -f routes/api-example-com-httproute.yaml
kubectl apply -f routes/apiproduct-1-httproute-1.yaml
kubectl apply -f routes/apiproduct-2-httproute.yaml

popd