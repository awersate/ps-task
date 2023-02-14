data "openstack_images_image_v2" "vm_image" {
  most_recent = true
  visibility  = "public"
  name        = var.vm_image_name
}

data "template_file" "user_data" {
  template = <<-EOT
              #!/bin/bash
              echo 'centos:centos' | sudo chpasswd
              yum upgrade -y
              # Установка и настройка sshd
              sudo sed -i 's/.*PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
              sudo systemctl restart sshd

              # Добавление приватного ключа
              echo "${file("~/.ssh/id_rsa")}" >> /home/centos/.ssh/id_rsa
              chown centos:centos /home/centos/.ssh/id_rsa
              chmod 400 /home/centos/.ssh/id_rsa

              # Установка Ansible
              sudo yum install -y epel-release
              sudo yum install -y ansible

              # Скачивание архива с ролями
              wget ${var.path_to_playbook_archive} 
              tar -xvf ansible.tar -C /home/centos

              # Создание файла hosts
              echo "
              [control]
              localhost
              [haproxy]
              ${openstack_compute_instance_v2.haproxy.access_ip_v4}
              [apache]
              ${join("\n", [for instance in values(openstack_compute_instance_v2.apache) : instance.access_ip_v4])}" >> /home/centos/ansible/hosts

              # Запуск ролей
              ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -u centos --key-file "/home/centos/.ssh/id_rsa" -i /home/centos/ansible/hosts /home/centos/ansible/setup_apache_haproxy.yml
              EOT
  depends_on = [
    openstack_compute_instance_v2.apache,
    openstack_compute_instance_v2.haproxy
  ]
}