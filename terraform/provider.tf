terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  user_name   = var.provider_user_name
  tenant_name = var.provider_tenant_name
  password    = var.provider_password
  auth_url    = var.provider_auth_url
  region      = var.provider_region
}
