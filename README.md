# Gloo Gateway HTTPRoute Delegation Reproducer

## Installation

Add Gloo Gateway Helm repo:
```
helm repo add glooe https://storage.googleapis.com/gloo-ee-helm
```

Export your Gloo Gateway License Key to an environment variable:
```
export GLOO_GATEWAY_LICENSE_KEY={your license key}
```

Install Gloo Gateway:
```
cd install
./install-gloo-gateway-with-helm.sh
```

> NOTE
> The Gloo Gateway version that will be installed is set in a variable at the top of the `install/install-gloo-gateway-with-helm.sh` installation script.

## Setup the environment

Run the `install/setup.sh` script to setup the environment:

- Create the required namespaces
- Deploy the Gateways (K8S Gateway API)
- Deploy the HTTPBin application
- Deploy the Reference Grants
- Deploy the HTTPRoutes (K8S Gateway API)

```
./setup.sh
```

## Access the HTTPBin application

Access API Product 1. This should work:

```
./curl-request-api1-example.com.sh
```

Access API Product 2. This fails with a 404, although it's using the same HTTPRoute reference as API Product 1.

```
./curl-request-api2-example.com.sh
```

Next, change the `apiproduct-1-httproute` to now directly reference the `HTTPBin` service instead of using the `HTTPRoute` delegate. Since now only the `apiproduct-2-httproute` is using the `httpbin-httproute` delegate, both api1 and api2 are accessible:

```
./curl-request-api1-example.com.sh
./curl-request-api2-example.com.sh
```
