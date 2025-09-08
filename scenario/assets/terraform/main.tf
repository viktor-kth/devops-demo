provider "docker" {}

resource "docker_network" "app" {
  name = "terraform-iac-net"
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