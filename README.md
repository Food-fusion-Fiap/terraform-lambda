# terraform-lambda

Este repositório contém as configurações do Terraform para criar uma Lambda.

## Configuração local

Antes de aplicar as configurações do Terraform, siga as etapas abaixo para configurar o ambiente local:

1. Defina a variável de ambiente `TF_VAR_jwt_secret` com o valor do segredo JWT necessário para a Lambda. Por exemplo:

```bash
export TF_VAR_jwt_secret=xxxxxxx
```

## Execução local

Após configurar a variável de ambiente, você pode aplicar as configurações do Terraform. Certifique-se de que o código da Lambda está presente localmente.

1. Compile o projeto `lambda-auth`, através do comando `make compile` e obtenha o arquivo ZIP resultante.
2. Coloque o arquivo ZIP na pasta `lambda-auth/dist/lambda_function.zip` neste repositório.

Em seguida, execute os comandos Terraform para aplicar as configurações e criar a Lambda:

```bash
terraform init
terraform apply
```

Após a aplicação bem-sucedida, sua Lambda estará pronta para uso.

Lembre-se de substituir `xxxxxxx` pelo valor real do segredo JWT necessário para sua aplicação.
