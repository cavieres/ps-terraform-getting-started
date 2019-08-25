# ps-terraform-getting-started
Terraform - Getting Started

Terraform v0.12.6

## Chapter 02

Using configuration described in:
- [Getting Started with IPv4 for Amazon VPC](https://docs.aws.amazon.com/vpc/latest/userguide/getting-started-ipv4.html)
- [Scenario 1: VPC with a Single Public Subnet](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario1.html)

`ps-tf-private-key-pair.pem` not versioned.

Notes:

```
VPC
- Gateway se asocia a VPC
- Route tables: Colocar Internet Gateway en Tabla de enrutamiento. > Tab Routes > dest: 0.0.0.0/0 Target: igw-.... (internet gw)
- Subnets: verif. que Route Table este apuntando a mismas rutas.

EC2
- Network interface (con IP privada) vincular a Elastic IP (IP Publica)
- Crear EC2 (ami-c58c1dd3) y asociar Network Interface (con su subnet asociada)
```