# terraform-lambda

Este repositório contém as configurações do Terraform para criar duas Lambdas:

1. **food-fusion-auth**: Responsável por criar o token de autenticação.
2. **food-fusion-authorizer**: Responsável por validar o token de autenticação, que será usado pelo API Gateway para verificar se o usuário tem permissão para acessar a aplicação do Go usando o Amazon EKS.

## Configuração local

Antes de aplicar as configurações do Terraform, siga as etapas abaixo para configurar o ambiente local:

1. Defina a variável de ambiente `TF_VAR_jwt_secret` com o valor do segredo JWT necessário para as Lambdas. Por exemplo:

```bash
export TF_VAR_jwt_secret=xxxxxxx
```

## Execução local

Após configurar a variável de ambiente, você pode aplicar as configurações do Terraform. Certifique-se de que o código das Lambdas está presente localmente.

1. Compile o projeto `lambda-auth`, através do comando `make compile`, e obtenha o arquivo ZIP resultante.
2. Coloque o arquivo ZIP na pasta `lambda-auth/dist/lambda_function.zip` neste repositório.

Em seguida, execute os comandos Terraform para aplicar as configurações e criar as Lambdas:

```bash
terraform init
terraform apply
```

Após a aplicação bem-sucedida, suas Lambdas estarão prontas para uso.

Lembre-se de substituir `xxxxxxx` pelo valor real do segredo JWT necessário para suas aplicações.