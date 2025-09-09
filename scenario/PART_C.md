# Terraform

Okay, so far we have looked at two approaches:

- Imperative (Docker CLI): typing out all instructions manually
- Declarative (Docker Compose): describing a set of services in YAML on a single machine.

Both methods are useful but they lack the ability to manage entire enviroments, with multiple servers, cloud networks, load balancers, firewalls, DNS etc.

This is where **Infrastructure as Code** (IAC) tools like Terraform come in, it allows us to:

- Declare full the infrastructure in configuration files
- Host across different providers (Docker, AWS, Azure, GCP, Kubernetes, etc.) using the same workflow.
- Track state and detect drift changes, so that we know whe  reality has diverged from our declaration
- Plan changes before applying the to the running infrastructure

Now lets look at how we would declare the same demo setup as we have setup in the previous two steps:

## C1 Defining the enviroment

Here we define the resource providers that are requirde to run the following terraform build, these resoruces are also called *plugins*. Each provider exposes a set of resources that can be declared. In our case we are using Docker provider, which allows Terraform to manage Docker images but this could easily be replaced with AWS or Kubernetes, or just use all three if necessary. 

**Note:** The Terraform configuration is written in a markup language called *HCL*.

`versions.tf`

```HCL
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}
```

---

In Terraform, instead of hardcoding values inside each resoruce, we can define **variables** in this dedicated file. This makes configuration easier to read and maintaine across differrent enviroments. This is comparable to for example and `.env` file.

`variables.tf`

```HCL
variable "host_port"   { type = number, default = 8080 }  # frontend (nginx) host port
variable "api_port"    { type = number, default = 9000 }  # backend host port
variable "nginx_tag"   { type = string, default = "stable" }
variable "backend_tag" { type = string, default = "0.2.3" }
variable "msg"         { type = string, default = "you spin me right round" }
```

---

This file defines the output which will appear when applying and running the Infrastucture.

`outputs.tf`

```HCL
output "frontend_url" {
  value       = "http://localhost:${var.host_port}"
  description = "Frontend (Nginx) URL"
}

output "api_url" {
  value       = "http://localhost:${var.api_port}"
  description = "Backend API direct URL"
}
```

---

Lastly we have the main file, this is where the resources that are required for running and creating the infrastructure is defined.

The keyword `resource` defines a resource and the first parameter is the type of the resource and the seccond parameter is the name within terraform that the resource gets.

Then the attributes for the resoruce are defined within the body.

`main.tf`

```HCL
provider "docker" {}

resource "docker_network" "app" {
  name = "iac-net"
}

resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_tag}"
  keep_locally = true
}

resource "docker_image" "api" {
  name         = "hashicorp/http-echo:${var.backend_tag}"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = "iac-demo"
  image = docker_image.nginx.image_id  

  ports {
    internal = 80
    external = var.host_port
  }

  volumes {
    host_path      =  abspath("${path.module}/../site")
    container_path = "/usr/share/nginx/html"
    read_only      = true
  }

  env = ["DEMO_MESSAGE=${var.msg}"]

  healthcheck {
    test         = ["CMD", "curl", "-f", "http://localhost/"]
    interval     = "10s"
    timeout      = "2s"
    start_period = "5s"
    retries      = 3
  }
  
  networks_advanced { name = docker_network.app.name }
  restart = "unless-stopped"
}

resource "docker_container" "api" {
  name  = "api"
  image = docker_image.api.image_id

  ports {
    internal = 5678
    external = var.api_port
  }

  command = ["-listen=:5678", "-text={\"service\":\"api\",\"status\":\"ok\"}"]

  networks_advanced { name = docker_network.app.name }
  restart = "unless-stopped"
}
```

As you might be able to tell, this file has a similar structure to the `docker-compose.yml` file. However the main difference between the two is as mentioned that the terraform file doesn't depend upon docker, but could be used to define any type of resources that is supported through *plugins*.

The other main difference is the lifecycle,

- For docker whenever the `docker compose up -d` command is run it starts the container and creates the defined resources immediately.
- However, for Terraform you instead start with creating a `plan` which you then `apply`, this process keeps track of the state and is therefore able to detect a drift within the infrastructure. You are then able to reconcile these drift changes back to the defined version of the infrastructure.
- Lastly, Terraform also creates a state file, and whenever you make changes to the configuration files and want to apply these changes, Terraform will create a plan describing the changes that are about to take place before the change is made. This allows the you, developer to review the changes before they are applied.

## C2 Start Terraform

The files that are outlined above can be found within the current tutorial system under the `/terraform` folder, to access it do `cd terraform`. Now you can view the files by writing a `ls` command.

Inorder to now start the terraform application now we need to run the following,

Initialize the project:

```bash
terraform init
```

This command donwloads the defined plugins from the `versions.tf` file and creates the local `.terraform` folder and creates or updates the state file `terraform.tfstate` which tracks the resources.

---

To preview the changes have been made and which will be applied when running the the `apply` command.

```bash
terraform plan
```

This command reads the `.tf` files and compares the desired state (config) with the real state (the running state & state file). It then outlines what will be created, changed and destoryed. The important part is that this command doesn't apply any of the changes it just scans and retunrs a **plan** of what will happen.

---

To finally apply the changes and exectute the changes we run the `apply` command.

```bash
terraform apply
```

This executes the changes and reconciles the running state with the currently defined state configuration. This command will by default prompt for a configuration, this can be skipped by adding the `-auto-approve` parameter.

now to ensure the enviroment is working we run:

```bash
curl http://localhost:9000 && curl http://localhost:8080
```

## C3 Drift Detection

To illustrate the one of the main differences between Docker Compose and Terraform, drift detection, we can do the following:

```bash
docker rm -f api
```

Now this would simulate an out-of-band change, because one of the underlying resources defined in Terraform is removed. If we now run:

```bash
terraform plan
```

Terraform will now detect that a resource is missing and plan to add it in the next `apply`, if we then run:

```bash
terraform apply -auto-approve
```

Terraform will now recreate the missing resoruce and you should now be able to run:

```bash
curl http://localhost:9000 && curl http://localhost:8080
```

And view both results.

This is something that Docker Compose is unable to do, whereas this is a fundamental part of Terraform, where changes can easily be detected and quickly reconciliated.

## C4 Clean up

When we are done, we destory everything with the following command:

```bash
terraform destroy -auto-approve
```

Terraform will show a destroy plan and the remove the containers. Lets move on to the final page to overview what we have learned.
