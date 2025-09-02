variable "host_port" {
  type        = number
  default     = 8080
}

variable "api_port" { 
  type = number
  default = 9000 
}

variable "nginx_tag" {
  type        = string
  default     = "stable"
}

variable "backend_tag" { 
  type = string
  default = "0.2.3" 
}

variable "msg" {
  type        = string
  default     = "you spin me right round"
}
