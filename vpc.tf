
resource "scaleway_vpc_private_network" "def_pn" {
  name = "def-pn"
}

resource "scaleway_vpc_public_gateway_dhcp" "def_dhcp" {
  subnet             = "192.168.0.0/24"
  push_default_route = true
  enable_dynamic     = false
  pool_low           = "192.168.0.20"
  pool_high          = "192.168.0.249"
}

resource "scaleway_vpc_public_gateway_ip" "def_pg_ip" {}

resource "scaleway_vpc_public_gateway" "def_pg" {
  name  = "def-pg"
  type  = "VPC-GW-S"
  bastion_enabled = true
  ip_id = scaleway_vpc_public_gateway_ip.def_pg_ip.id
}

resource "scaleway_vpc_gateway_network" "def_gn" {
  gateway_id         = scaleway_vpc_public_gateway.def_pg.id
  private_network_id = scaleway_vpc_private_network.def_pn.id
  dhcp_id            = scaleway_vpc_public_gateway_dhcp.def_dhcp.id
  cleanup_dhcp       = true
  enable_masquerade  = true

  depends_on = [
    scaleway_vpc_public_gateway_ip.def_pg_ip,
    scaleway_vpc_public_gateway.def_pg,
    scaleway_vpc_private_network.def_pn
  ]
}

resource "scaleway_vpc_public_gateway_dhcp_reservation" "def_pg_dhcp_res_def_instance" {
  gateway_network_id = scaleway_vpc_gateway_network.def_gn.id
  mac_address        = scaleway_instance_private_nic.def_instance_pnic01.mac_address
  ip_address         = "192.168.0.10"

  depends_on = [
    scaleway_vpc_public_gateway_dhcp.def_dhcp,
    scaleway_vpc_gateway_network.def_gn,
    scaleway_instance_private_nic.def_instance_pnic01
  ]
}