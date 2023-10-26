# About
Terraform project to deploy a static website (dev and stage) on AWS using Nginx as a backend webserver.

# Some resources being used
- EC2
- Auto Scaler Group
- Application Load Balancer
- S3 Bucket Access Point
- Transit Gateway
- S3 VPC Endpoint (Gateway)
- Route53
- Certificate manager
- Nginx

# Install Requirements
```
terraform
terragrunt
```

# Considerations
- Terragrunt is going to automatically generate the S3 remote state and provider config files.
- This terraform project assumes the IAM Role "arn:aws:iam::123456789:role/terragrunt" to apply the terraform, therefore this role requires a lot of permissions.

# Terraform Apply
## Networking
```
cd terraform/shared/us-east-1/tgw/
terragrunt apply
cd terraform/stage/us-east-1/network/
terragrunt apply
cd terraform/dev/us-east-1/network/
terragrunt apply
cd terraform/shared/us-east-1/route53/
terragrunt apply
```

## Load Balancers
```
cd terraform/stage/us-east-1/lb/
terragrunt apply
cd terraform/dev/us-east-1/lb/
terragrunt apply
```

## Website Service
```
cd terraform/stage/us-east-1/services/website/
terragrunt apply
cd terraform/dev/us-east-1/services/website/
terragrunt apply
```

# Terraform Destroy
## Website Service
```
cd terraform/stage/us-east-1/services/website/
terragrunt destroy
cd terraform/dev/us-east-1/services/website/
terragrunt destroy
```

## Load Balancers
```
cd terraform/stage/us-east-1/lb/
terragrunt destroy
cd terraform/dev/us-east-1/lb/
terragrunt destroy
```

## Networking
```
cd terraform/shared/us-east-1/route53/
terragrunt destroy
cd terraform/stage/us-east-1/network/
terragrunt destroy
cd terraform/dev/us-east-1/network/
terragrunt destroy
cd terraform/shared/us-east-1/tgw/
terragrunt destroy
```
