resource "scaleway_lb_ip" "def_lb_ip" {}

resource "scaleway_lb" "def_lb" {
  name   = "def-load-balancer"
  ip_ids = [scaleway_lb_ip.def_lb_ip.id]
  zone   = var.scw_zone
  type   = var.def_lb_type

  private_network {
    private_network_id = scaleway_vpc_private_network.def_pn.id
    dhcp_config        = true
  }

  depends_on = [
    scaleway_vpc_public_gateway.def_pg
  ]
}

resource "scaleway_lb_frontend" "def_lb_frontend" {
  lb_id        = scaleway_lb.def_lb.id
  backend_id   = scaleway_lb_backend.def_lb_backend.id
  name         = "def-frontend"
  inbound_port = "80"
}

resource "scaleway_lb_backend" "def_lb_backend" {
  lb_id            = scaleway_lb.def_lb.id
  name             = "def-backend"
  forward_protocol = "http"
  forward_port     = "80"
  server_ips       = [data.scaleway_ipam_ip.def_private_ip.address]

  health_check_http {
    uri    = "/"
    method = "GET"
    code   = 200
  }

  depends_on = [
    scaleway_instance_server.def_instance
  ]
}
