locals {
  named_ports = [{
    name = "health-check-port"
    port = 6666
  }]

  health_check = {
    type                = "tcp"
    check_interval_sec  = 10
    healthy_threshold   = 4
    timeout_sec         = 10
    unhealthy_threshold = 5
    response            = ""
    proxy_header        = "NONE"
    port                = 6666
    port_name           = "health-check-port"
    request             = ""
    request_path        = "/"
    host                = ""
  }
}