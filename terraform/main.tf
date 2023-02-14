resource "openstack_compute_keypair_v2" "ssh" {
  name       = "keypair"
  public_key = file(var.ssh_public_key_path)
}

module "vpc" {
  source = "./modules/vpc"
  cidr=var.cidr
  dns_nameservers=var.dns_nameservers
  ip_version=var.ip_version
  enable_dhcp=var.enable_dhcp
  external_network_id=var.external_network_id
}

resource "openstack_networking_floatingip_v2" "instance_fip" {
  pool = var.floating_ip_pool
}

# Haproxy
resource "openstack_compute_secgroup_v2" "security_group_web" {
  name        = "sg_web"
  description = "open all icmp, ssh, and http"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_blockstorage_volume_v3" "volume_haproxy" {
  name                 = "volume_haproxy"
  size                 = var.volume_haproxy_size
  image_id             = data.openstack_images_image_v2.vm_image.id
  volume_type          = var.volume_haproxy_type
  enable_online_resize = true
}

resource "openstack_compute_instance_v2" "haproxy" {
  name            = "haproxy"
  flavor_name     = var.instance_haproxy_flavor_name
  key_pair        = openstack_compute_keypair_v2.ssh.name
  security_groups = [openstack_compute_secgroup_v2.security_group_web.id]
  depends_on      = [
    module.vpc,
    openstack_blockstorage_volume_v3.volume_haproxy
  ]
  network {
    uuid = module.vpc.network_id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_haproxy.id
    boot_index            = 0
    source_type           = "volume"
    destination_type      = "volume"
    delete_on_termination = var.volume_delete_on_termination
  }
}

resource "openstack_compute_floatingip_associate_v2" "instance_fip_association" {
  floating_ip = openstack_networking_floatingip_v2.instance_fip.address
  instance_id = openstack_compute_instance_v2.haproxy.id
  fixed_ip    = openstack_compute_instance_v2.haproxy.access_ip_v4
  depends_on = [
    openstack_compute_instance_v2.haproxy,
    openstack_networking_floatingip_v2.instance_fip
  ]
}

# Control VM
resource "openstack_compute_secgroup_v2" "security_group_control" {
  name        = "sg_control"
  description = "open all icmp, ssh, and http"
  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_blockstorage_volume_v3" "volume_control" {
  name                 = "volume_control"
  size                 = var.volume_control_size
  image_id             = data.openstack_images_image_v2.vm_image.id
  volume_type          = var.volume_control_type
  enable_online_resize = true
}

resource "openstack_compute_instance_v2" "control" {
  name            = "control"
  flavor_name     = var.instance_control_flavor_name
  key_pair        = openstack_compute_keypair_v2.ssh.name
  security_groups = [openstack_compute_secgroup_v2.security_group_control.id]
  depends_on      = [
    module.vpc,
    openstack_blockstorage_volume_v3.volume_control
  ]
  user_data       = data.template_file.user_data.rendered
  network {
    uuid = module.vpc.network_id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_control.id
    boot_index            = 0
    source_type           = "volume"
    destination_type      = "volume"
    delete_on_termination = var.volume_delete_on_termination
  }
}

# Apache servers
resource "openstack_blockstorage_volume_v3" "volume_apache" {
  for_each             = { for i in range(var.apache_vm_count) : "volume_apache_${i}" => i }
  name                 = each.key
  size                 = var.volume_apache_size
  image_id             = data.openstack_images_image_v2.vm_image.id
  volume_type          = var.volume_apache_type
  enable_online_resize = true
}

resource "openstack_compute_instance_v2" "apache" {
  for_each        = { for i in range(var.apache_vm_count) : "apache_${i}" => i }
  name            = each.key
  flavor_name     = var.instance_apache_flavor_name
  key_pair        = openstack_compute_keypair_v2.ssh.name
  security_groups = [openstack_compute_secgroup_v2.security_group_web.id]
  depends_on      = [
    module.vpc,
    openstack_blockstorage_volume_v3.volume_apache
  ]
  network {
    uuid = module.vpc.network_id
  }
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_apache["volume_${each.key}"].id
    boot_index            = 0
    source_type           = "volume"
    destination_type      = "volume"
    delete_on_termination = var.volume_delete_on_termination
  }
}
