terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.76.0"
    }
  }
}

provider "yandex" {
  cloud_id                 = "b1gpuk20vvnlp2qipvj0"  
  folder_id                = "b1g6qc9bv32bmet65ai1"  
  zone                     = "ru-central1-a"         
  service_account_key_file = "authorized_key.json"
}

variable "vm_count" {
  type    = number
  default = 3
}

resource "yandex_compute_instance" "k8s_node" {
  count       = var.vm_count
  name        = "k8s-node-${count.index + 1}"
  platform_id = "standard-v2"

  resources {
    cores  = 2
    memory = 4   
  }

  boot_disk {
    initialize_params {
      image_id = "fd85u0rct32prepgjlv0"  # Ubuntu 22.04 
      size     = 50                     
    }
  }

  network_interface {
    subnet_id = "e9b91oiqvs6pr90m0gf2" 
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
