resource "scaleway_instance_security_group" "def_security_group" {
  name                   = "def-sg"
  inbound_default_policy = "drop"
  external_rules         = true
}

resource "scaleway_instance_server" "def_instance" {
  name              = "instance-def-nginx"
  type              = "PLAY2-PICO"
  zone              = "fr-par-2"
  image             = "ubuntu_noble"
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

resource "scaleway_instance_private_nic" "def_instance_pnic01" {
  server_id          = scaleway_instance_server.def_instance.id
  private_network_id = scaleway_vpc_private_network.def_pn.id

  depends_on = [
    scaleway_instance_server.def_instance
  ]
}
