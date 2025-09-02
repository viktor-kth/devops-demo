variable "host_port" {
  description = "Host port for Nginx"
  type        = number
  default     = 8080
}

variable "nginx_tag" {
  description = "Nginx image tag"
  type        = string
  default     = "stable"
}

variable "msg" {
  description = "Message to show in logs"
  type        = string
  default     = "you spin me right round"
}
