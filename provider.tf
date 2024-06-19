provider "scaleway" {
  zone   = "fr-par-2"
  region = "fr-par"
  project_id = "71cf4c5b-2be9-435d-a2a1-9b912ef41e73"
}

terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.41.2"
    }
  }
  required_version = ">= 1.0.0"
}
