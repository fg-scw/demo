resource "scaleway_instance_security_group" "def_security_group" {
  name                   = "def-sg"
  zone                   = var.scw_zone
  inbound_default_policy = "drop"
  external_rules         = true
}

resource "scaleway_instance_server" "def_instance" {
  name  = "instance-def-nginx"
  type  = "PLAY2-PICO"
  zone  = var.scw_zone
  image = "ubuntu_noble"
  user_data = {
    cloud-init = <<-EOT
            #cloud-config
            runcmd:
                - apt-get update && apt-get upgrade -y
                - apt-get install nginx -y
                - sudo systemctl reboot
            EOT
  }
  security_group_id = scaleway_instance_security_group.def_security_group.id
  tags              = ["def", "test"]

  root_volume {
    size_in_gb            = "10"
    delete_on_termination = true
  }
}

# Connect your instance to a private network using a private nic.
resource "scaleway_instance_private_nic" "def_nic" {
  zone               = var.scw_zone
  server_id          = scaleway_instance_server.def_instance.id
  private_network_id = scaleway_vpc_private_network.def_pn.id
}

# Find server private IPv4 using private-nic mac address
data "scaleway_ipam_ip" "by_mac" {
  mac_address = scaleway_instance_private_nic.def_nic.mac_address
  type        = "ipv4"
}

# Find server private IPv4 using private-nic id
data "scaleway_ipam_ip" "def_private_ip" {
  resource {
    id   = scaleway_instance_private_nic.def_nic.id
    type = "instance_private_nic"
  }
  type = "ipv4"
}
