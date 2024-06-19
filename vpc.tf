resource "scaleway_vpc" "vpc01" {
  name = "my vpc"
  enable_routing = true
}

resource "scaleway_vpc_private_network" "def_pn" {
  region              = var.scw_region
  name = "def-pn"
  ipv4_subnet {
    subnet = "192.168.0.0/24"
  }
  vpc_id = scaleway_vpc.vpc01.id
}

resource "scaleway_vpc_public_gateway_ip" "def_pg_ip" {}

resource "scaleway_ipam_ip" "ip01" {
  address = "192.168.0.7"
  source {
    private_network_id = scaleway_vpc_private_network.def_pn.id
  }
}

resource "scaleway_vpc_public_gateway" "def_pg" {
  name            = "def-pg"
  type            = "VPC-GW-S"
  bastion_enabled = true
  ip_id = scaleway_vpc_public_gateway_ip.def_pg_ip.id
}

resource "scaleway_vpc_gateway_network" "def_gn" {
  zone              = var.scw_zone
  gateway_id         = scaleway_vpc_public_gateway.def_pg.id
  private_network_id = scaleway_vpc_private_network.def_pn.id
  enable_masquerade  = true
  ipam_config {
    push_default_route = true
    ipam_ip_id         = scaleway_ipam_ip.ip01.id
  }
  cleanup_dhcp = true
}
