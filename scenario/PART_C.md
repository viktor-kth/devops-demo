# Commands

lets say you have a shared docker container hosted somewhere

## C1 Start terraform

``
terraform init
terraform plan
terraform apply
``

## C2 Ensure they are working

```bash
curl http://localhost:9000 && curl http://localhost:8080
```