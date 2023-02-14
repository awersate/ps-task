resource "openstack_networking_network_v2" "private_network" {
  name           = "private_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "private_subnet"
  network_id      = openstack_networking_network_v2.private_network.id
  cidr            = var.cidr
  dns_nameservers = var.dns_nameservers
  ip_version      = var.ip_version
  enable_dhcp     = var.enable_dhcp
  depends_on      = [openstack_networking_network_v2.private_network]
}

data "openstack_networking_network_v2" "external_network" {
  external = true
}

resource "openstack_networking_router_v2" "router" {
  name                = "router"
  external_network_id = data.openstack_networking_network_v2.external_network.id
  admin_state_up      = "true"
  depends_on          = [openstack_networking_network_v2.private_network]
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id  = openstack_networking_router_v2.router.id
  subnet_id  = openstack_networking_subnet_v2.private_subnet.id
  depends_on = [openstack_networking_router_v2.router]
}
