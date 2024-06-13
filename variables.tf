
# scaleway

variable "scw_region" {
  default = "fr-par"
  type    = string
}

variable "scw_zone" {
  default = "fr-par-2"
  type    = string
}


## def instance
#

variable "def_instance_type" {
  default = "PLAY2-NANO"
  type    = string
}

#
## load balancer
#

variable "def_lb_type" {
  default = "LB-S"
  type    = string
}

#
## ssh
#

variable "ssh_private_key_path" {
  default = "~/.ssh/id_rsa"
  type    = string
}