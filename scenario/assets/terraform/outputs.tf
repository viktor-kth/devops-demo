output "frontend_url" {
  value       = "http://localhost:${var.host_port}"
  description = "Frontend (Nginx) URL"
}

output "api_url" {
  value       = "http://localhost:${var.api_port}"
  description = "Backend API direct URL"
}