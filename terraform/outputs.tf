output "haproxy" {
  value = "Haproxy: ${openstack_compute_instance_v2.haproxy.access_ip_v4}, ${openstack_networking_floatingip_v2.instance_fip.address}"
}

output "control" {
  value = "Control: ${openstack_compute_instance_v2.control.access_ip_v4}"
}

output "apache" {
  value = tomap({for instance in openstack_compute_instance_v2.apache : instance.name => instance.access_ip_v4})
}