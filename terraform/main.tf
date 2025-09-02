provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:${var.nginx_tag}"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = "web-demo"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.host_port
  }

  volumes {
    host_path      = abspath("${path.module}/../site")
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
}
