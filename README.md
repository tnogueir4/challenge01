# Challenge01


<!--ts-->
 - [Sobre](#sobre)
 - [Cluster AWS EKS](#cluster)
    - [Módulos](#modulos)
    - [Providers](#providers)


<!--te-->
<br/>

---

<br/>

## <a name="sobre">Sobre</a>
Challenge01 é um projeto de desafio técnico que visa a criação de um ambiente em núvem pública com os seguintes requisitos:

 * Configurar um cluster Kubernetes em um plataforma de nuvem (neste caso, optamos por AWS) utilizando Terraform.
 * Desenvolver um conjunto de manifestos Kubernetes, Helm ou Kustomize para provisionar uma aplicação simples (qualquer api rest disponível no dockerhub) em um cluster kubernetes.
 * Configurar o acesso externo à aplicação usando um LoadBalancer ou ingress.
 * Criar uma estratégia de HPA.
 * Criar uma pipeline de CI/CD (de sua preferência desde que seja como código) que permita que uma aplicação seja implantada automaticamente no cluster Kubernetes quando houver uma atualização em um repositório GIT.

<br/>

## <a name="cluster">Cluster AWS EKS</a>

<p>Para provisionarmos o cluster EKS, iremos utilizar o <a href="https://www.terraform.io">terraform</a>, ferramenta de IaC (Infrastructure As Code) desenvolvida pela <a href="https://www.hashicorp.com">Hashicorp</a>.</p>
<p>Estaremos fazendo uso de módulos do terraform para o cluster eks. Para maiores informações sobre modulos do terraform, consulte a <a href="https://developer.hashicorp.com/terraform/language/modules">documentação oficial</a>.

<br/>

### **<a name="modulos">Módulos</a>**

<p>Para esse exemplo, vamos utilizar 2 módulos (considerando um ambiente novo), módulo para VPC e para EKS.</p>

<br/>

**MODULO VPC**

Módulo utilizado para criação parametrizada de novas VPC's.

Exemplo de uso:

```
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

```

<p> Este módulo possui um total de <b>220 inputs</b>, <b>109 outputs</b> e <b>78 resources</b>. A lista completa pode ser verificada na documentação do <a href="https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest">módulo VPC</a>.</p>

<br/>

**MODULO EKS**

Módulo utilizado para o provisionamento de um novo cluster EKS.

Exemplo de uso:

```
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.5.1"

  cluster_name    = local.cluster_name
  cluster_version = "1.24"

  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}
```
<p> Este módulo possui um total de <b>90 inputs</b>, <b>33 outputs</b> e <b>49 resources</b>. A lista completa pode ser verificada na documentação do <a href="https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest">módulo EKS</a>.</p>

<br/>

### **<a name="providers">Providers</a>**

<p>Um provider (provedor) no Terraform é um componente que permite ao Terraform interagir com um determinado serviço e/ou plataforma de infraestrutura. Ele age como uma ponte entre o Terraform e o serviço alvo, permitindo a criação, atualização e remoção de recursos nesse serviço específico. </p>
<p> Os providers são essenciais no Terraform fornecendo as API's e recursos necessários para que o Terraform gerencie a infraestrutura como código. Dependendo de como seu código é estruturado e de quais recursos você utilizará, 2 ou mais provedores podem ser requeridos, gerando assim, uma dependência de providers. </p>
<p>Abaixo estão especificados os providers necessários para o nosso projeto <b>Challenge01</b>:</p>

| Provider | Versão | Descrição |
|---|---|---|
| `hashicorp/aws` | `~> 4.47.0` | Provider específico para AWS (Amazon Web Services), permitindo a criação, configuração e gerenciamento de recursos e serviços. |
| `hashicorp/random` | `~> 3.4.3` | Provider específico para gerar valores aleatórios ou pseudoaleatórios durante o processo de implantação da infraestrutura. |
| `hashicorp/tls` | `~> 4.0.4` | Provider para funcionalidades relacionadas à segurança, criptografia e certificados TLS (Transport Layer Security). |
| `hashicorp/cloudinit` | `~>2.2.0` | Provider que permite a definição de metadados na configuração inicial de instâncias de vm's. |