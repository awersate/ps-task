# PS Cloud task
### Description:

Using Terraform, you need to provision 5 servers and configure them. 

Configure HAproxy to balance load so that when accessing a static address in the browser, the website with a greeting "Welcome to <hostname>" is opened from one of three servers, and on refreshing the page, the website should be opened from another server. 

For example, when accessing the website through a static address, the website opens from the VM1 server with the message "Welcome to VM1," and when the page is refreshed, the information should be taken from the VM2 server with the message "Welcome to VM2," and so on.

What needs to be done:

### Terraform
* Create 5 VMs (CentOS OS) (4 VMs are empty, and 1 VM is for control to run Ansible roles)
* Assign a floating IP to the VM with HAproxy
* Install required packages on the control VM
* Fix local (private) IP addresses
* Run the Ansible role
### Ansible
* Configure 1 HAproxy and 3 Apache servers
* Create an index.html file with the message "Welcome to <hostname>" in /opt/html/ directory on Apache servers
* Disabling SElinux is not allowed
* Ansible roles should be located in S3.

Define variables in `variables.tf`

Run 
```hcl
terraform init
terraform apply
```