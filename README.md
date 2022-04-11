# WIP

`repo : aws-eks-gitops`

Practical gitops CI/CD with terraform,eks

terraform init
terraform plan -var-file=vars.tfvars

aws eks --region ap-south-1 create-cluster --name ManualClusterTest --role-arn arn:aws:iam::010621237612:role/manual-eks --resources-vpc-config subnetIds=subnet-02233f40130bddfa9,subnet-0346036497187f3af,securityGroupIds=sg-09c6537416e8152c4

aws eks --region ap-south-1 create-cluster --name eks-manual-cluster --role-arn arn:aws:iam::010621237612:role/eks-manual-cluster-role --resources-vpc-config subnetIds=subnet-0615d6a2b44db63d4,subnet-07d660917d9598d70

aws eks --region ap-south-1 update-kubeconfig --name eks-manual-cluster

aws eks --region ap-south-1 describe-cluster --name eks-manual-cluster --query cluster.status

kustomize build kustomizations/overlays/prod > k8s-manifest/deployment.yaml


TODO:

MainCluster
- To deploy the example app cluster
- CI/CD the k8s manifest files.
- Service expose - ALB/
- Domain mapping.
- ArgoCD cluster
- Setup ArgoAutomated deploy

