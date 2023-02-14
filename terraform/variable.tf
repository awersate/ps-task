# Connection to provider
variable "provider_user_name" {
  description = "User for connection to provider"
  type = string
  default = ""
}

variable "provider_tenant_name" {
  description = "Tennant for connection to provider"
  type = string
  default = ""
}

variable "provider_password" {
  description = "Password for connection to provider"
  type = string
  default = ""
}

variable "provider_auth_url" {
  description = "URL auth for connection to provider"
  type = string
  default = "https://auth.pscloud.io/v3/"
}

variable "provider_region" {
  description = "Region for connection to provider"
  type = string
  default = "kz-ala-1"
}

# Path to ansible playbook archive
# important name archive is "ansible" and using tar or tar.gz 
# otherwise the script in the "datasource.tf" must be changed
variable "path_to_playbook_archive" {
  description = "Path to ansible playbook archive, "
  type = string
  default = "https://ansible.archive.pscloud.io/ansible.tar"
}

# Common vars
variable "vm_image_name" {
  description = "VM image name in provider"
  type        = string
  default     = "CentOS-Stream-9-x86_64-202112"
}

variable "ssh_public_key_path" {
  description = "Path to ssh public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Path to ssh private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

# Vars for private subnet
variable "cidr" {
  description = "CIDR for private subnet"
  type        = string
  default     = "192.168.0.0/24"
}

variable "dns_nameservers" {
  description = "DNS servers for private subnet"
  type        = list(any)
  default     = ["195.210.46.195", "195.210.46.132"]
}

variable "ip_version" {
  description = "IP version for private subnet"
  type        = number
  default     = 4
}

variable "enable_dhcp" {
  description = "DHCP for private subnet"
  type        = bool
  default     = true
}

variable "external_network_id" {
  description = "External network id"
  type        = string
  default     = "0bc2241d-36e4-4edb-8b12-ce9e2c837c45"
}

variable "floating_ip_pool" {
  description = "Floating IP pool"
  type        = string
  default     = "FloatingIP Net"
}

variable "volume_delete_on_termination" {
  description = "Delete volume on termination"
  type        = bool
  default     = false
}

# Vars for haproxy
variable "volume_haproxy_size" {
  description = "Size for Vm haproxy volume"
  type        = number
  default     = 30
}

variable "volume_haproxy_type" {
  description = "Volume type for haproxy"
  type        = string
  default     = "ceph-hdd"
}

variable "instance_haproxy_flavor_name" {
  description = "Flavor name for haproxy"
  type        = string
  default     = "d1.ram2cpu1"
}

# Vars for control
variable "volume_control_size" {
  description = "Size for Vm control volume"
  type        = number
  default     = 30
}

variable "volume_control_type" {
  description = "Volume type for control"
  type        = string
  default     = "ceph-hdd"
}

variable "instance_control_flavor_name" {
  description = "Flavor name for control"
  type        = string
  default     = "d1.ram4cpu2"
}

# Vars for apache
variable "apache_vm_count" {
  description = "Count VM apache"
  type        = number
  default     = 3
}

variable "volume_apache_size" {
  description = "Size for Vm apache volume"
  type        = number
  default     = 30
}

variable "volume_apache_type" {
  description = "Volume type for apache"
  type        = string
  default     = "ceph-hdd"
}

variable "instance_apache_flavor_name" {
  description = "Flavor name for apache"
  type        = string
  default     = "d1.ram1cpu1"
}
