#!/usr/bin/env sh

if [ -z "$1" ] || [ -z "$2" ];
  then
    echo "No GCP project Name and E-Mail for cluster certificate passed to script: install.sh <GCP_DNS_PROJECT_NAME> <GCP_USER_CONTACT>"
    exit 1
fi

# Export Variables to environment
export GCP_DNS_PROJECTNAME=$1
export GCP_USER_CONTACT=$2

#Install Helm (Additional RBAC Role required)

echo "Install Helm Tiller on Kubernetes Cluster"

kubectl apply -f configs/helm_rbac_role.yaml
helm init --service-account tiller --upgrade --wait

#Install Additional K8s Services

echo "Create Secret for CloudDNS Service Account"
kubectl apply -f ../06_secrets/clouddns_secret.yaml
#External DNS for DNS Record Management

echo "Install external-dns on Kubernetes Cluster (helm)"

helm upgrade -i --namespace kube-system external-dns stable/external-dns --set-string provider=google,txtOwnerId="external-dns managed",domainFilters={"endocodelab.com"},google.project=$GCP_DNS_PROJECTNAME,rbac.create=true,google.serviceAccountSecret="clouddns-svc-secret" --force


#Cert Manager for automatical provision Lets Encrypt Certificates

echo "Install Certificate Manager on Kubernetes Cluster (helm)"

helm upgrade -i  --namespace kube-system  cert-manager stable/cert-manager --force
kubectl apply -f configs/cert_manager.yaml

# Install Istio with Side Car Containers 

echo "Install Istio with Sidecar injection (helm)"

helm install ./istio --name istio --namespace istio-system