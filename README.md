# ps-terraform-getting-started
Terraform - Getting Started

## Version used

Terraform v0.12.6

## Ejecution:
```
terraform plan -var-file='..\terraform.tfvars'
terraform init
terraform apply -var-file="..\terraform.tfvars"
terraform destroy -var-file="..\terraform.tfvars"
```

## Enter VM
```
ssh -i '/c/Users/cavie/Desarrollo/github-cavieres/ps-terraform-getting-started/ps-tf-private-key-pair.pem' ec2-user@<public_ip>
```

## `terraform.tfvars`
```
aws_access_key = "AKIAZTCLMQ6UH6WSNSFD"

aws_secret_key = "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"

private_key_path = "~/Desarrollo/github-cavieres/ps-terraform-getting-started/ps-tf-private-key-pair.pem"
```

## AWS access/secret Key

Gotten from Services > IAM

## ps-tf-private-key-pair.pem

Generated in Services > EC2 > NETWORK & SECURITY > Key Pairs

## Notes:
```
VPC
- Gateway se asocia a VPC
- Route tables: Colocar Internet Gateway en Tabla de enrutamiento. > Tab Routes > dest: 0.0.0.0/0 Target: igw-.... (internet gw)
- Subnets: verif. que Route Table este apuntando a mismas rutas.

EC2
- Network interface (con IP privada) vincular a Elastic IP (IP Publica)
- Crear EC2 (ami-c58c1dd3) y asociar Network Interface (con su subnet asociada)
```

## Chapter 02

Using configuration described in:
- [Getting Started with IPv4 for Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html)
- [Scenario 1: VPC with a Single Public Subnet](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario1.html)