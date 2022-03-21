terraform {
  required_providers {
    digitalocean = {
      source = "terraform-providers/digitalocean"
      version = "~> 2.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
