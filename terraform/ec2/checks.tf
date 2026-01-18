data "external" "nginx_http" {
  program    = ["python3", "${path.module}/scripts/check_nginx.py"]
  query      = { url = "http://${aws_instance.nginx.public_ip}/" }
  depends_on = [aws_instance.nginx]
}

check "nginx_http_200" {
  assert {
    condition     = tonumber(data.external.nginx_http.result.status_code) == 200
    error_message = "Nginx healthcheck failed: expected HTTP 200, got ${data.external.nginx_http.result.status_code}."
  }
}
