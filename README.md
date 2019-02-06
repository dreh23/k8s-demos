# Kubernetes Demo Environment


## Requirements

Following applications are required to execute / deploy the demo environment:

* [kubectl]()
* [HashiCorp Terraform]()
* [Helm]()
* [gcloud CLI Tools]()
* [git-crypt](https://github.com/AGWA/git-crypt)

## Decrypt Secrets
All secrets in the directory _06_secrets_ are encrypted using [git-crypt](https://github.com/AGWA/git-crypt). 

To decrypt the required secrets run `git-crypt unlock <Path_to_Keyfile>` in the secrets directory. The key file is stored at the [internal Wiki](https://tracker.endocode.com/projects/it/wiki/Endocodelab).
## Installation   

### Create Kubernetes Cluster



### Get Credentials for new Cluster

Since we have a Regional Cluster we have to use a workaround in _gcloud_ to get the Cluster Credentials.

Run following commands:

* `export CLOUDSDK_CONTAINER_USE_V1_API_CLIENT=false && export CLOUDSDK_CONTAINER_USE_V1_API=false`
* `gcloud beta container clusters get-credentials <cluster_name> --region <cluster_region>`

## Extensions

Deploy all extensions by running the Shell script using e.g. _./install.sh endocodelab-dns <your_email>@endocode.com_.

Following extensions will be installed:
- [ExternalDNS](https://github.com/kubernetes-incubator/external-dns)
- [Helm](https://github.com/kubernetes/helm)
- [CertManager](https://github.com/jetstack/cert-manager)
- [Istio](https://istio.io/)

## Application

We use the Weave Socks Shop as an example application for our demo environment.


## Kubernetes Tools

 - [Stern](https://github.com/wercker/stern) - Query Logs of multiple pods at once
 - [Jaeger](https://github.com/jaegertracing/jaeger) - Trace connections between Containers using Istio
 - [Telepresence](https://github.com/telepresenceio/telepresence) - Tool to debug container running in Kubernetes locally

 ## Security Tools

### Requirements
 To install _Security Monkey_ or _HashiCorp Vault_  the third-party Terraform Provider [ACME](https://github.com/vancluever/terraform-provider-acme/releases) for certificate generation is required.


 The provider has to be installed manually by:
 * On Windows, in the sub-path terraform.d/plugins beneath your user's "Application Data" directory.
* On all other systems, in the sub-path .terraform.d/plugins in your user's home directory. 

 ### Security Monkey





 ### HashiCorp Vault



