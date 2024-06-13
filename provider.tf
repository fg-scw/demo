provider "scaleway" {
}

terraform {
    required_providers {
        scaleway = {
            source  = "scaleway/scaleway"
            version = ">= 2.41.0"
        }
    }
    required_version = ">= 1.0.0"
}