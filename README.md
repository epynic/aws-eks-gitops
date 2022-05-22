# GitOps way to k8s and application delivery
 
A practical GitOps CI/CD with declarative descriptions of the infrastructure and automated process to handle deployments.

This project uses the the docker-vote example app. (https://github.com/dockersamples/example-voting-app) wrapped to run on k8s cluster.

Resources :
` aws-codebuild, aws-codecommit, aws-codepipeline, terraform, aws-eks, argo-cd, kustomize. `

## What is GitOps
(https://www.weave.works/technologies/gitops/)

## Prerequisites
AWS account
AWS profile configured with CLI. ( try https://github.com/epynic/aws-terraform-ec2-instance to provision a jump-server)
Terraform
kubectl


### Project/File Structure

```
.
├── application         # docker-example-vote app 
│   ├── db
│   ├── redis
│   ├── result
│   ├── vote
│   └── worker
├── docker-compose.yaml 
├── ingress-controller # ingress controller setup
├── k8s-manifest       # manifest files output from kustomizations
├── kustomizations     # kustomizations base template
├── terraform
│   ├── codebuild.tf
│   ├── codecommit.tf
│   ├── codepipeline.tf
│   ├── ecr.tf
│   ├── eks
│   ├── eks.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── route53.tf
│   ├── s3.tf
│   ├── variables.tf
│   ├── vars.tfvars
│   ├── vpc
│   │   ├── outputs.tf
│   │   ├── sg_dataplane.tf
│   │   ├── sg_public.tf
│   │   ├── variables.tf
│   │   └── vpc.tf
│   └── vpc.tf
└── .gitignore
```

# How to run

1. Clone the repo.

``` 
git clone https://github.com/epynic/aws-eks-gitops
```

2. Initialize Terraform

```
cd terraform
terraform init
terraform plan -var-file=vars.tfvars
```

3. To access the eks cluster update kubeconfig
```
aws eks --region ap-south-1 update-kubeconfig --name vote-gitops-ci-cd-eks-cluster
kubectl get nodes
```

4. Ingress controller installation
Follow the AWS guild to complete the ingress-controller installation.

https://docs.aws.amazon.com/eks/latest/userguide/aws-load-balancer-controller.html

Note: This are AWS account specific, update the required variables according to the guide mentioned.

```
aws iam create-policy \
 --policy-name AWSLoadBalancerControllerIAMPolicy \
 --policy-document file://ingress-controller/iam_policy.json
```

```
aws eks describe-cluster --name vote-gitops-ci-cd-eks-cluster --query "cluster.identity.oidc.issuer" --output text
```

```
aws iam create-role \
 --role-name AmazonEKSLoadBalancerControllerRole \
 --assume-role-policy-document file://ingress-controller/load-balancer-role-trust-policy.json
```
```
aws iam attach-role-policy \
 --policy-arn arn:aws:iam::010621237612:policy/AWSLoadBalancerControllerIAMPolicy \
 --role-name AmazonEKSLoadBalancerControllerRole
```

```
kubectl apply -f aws-load-balancer-controller-service-account.yaml
```
```
kubectl apply \
 --validate=false \
 -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
```
```
kubectl apply -f ingress-controller/v2_4_1_full.yaml
```

4. ArgoCD installation -

Follow guide from https://argo-cd.readthedocs.io/en/stable/getting_started/

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

To configure ArgoCD
```
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:443
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

### argocd-cli installation
```
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```

Connect repo in argo-cd
```
argocd login <SERVER-IP>
add remote cluster config
kubectl config get-contexts -o name
argocd cluster add arn:aws:eks:ap-south-1:xxxxxxxxxxxxx:cluster/vote-gitops-ci-cd-eks-cluster
```

Add project repository in argo 
Create the project in argocd with auto-sync