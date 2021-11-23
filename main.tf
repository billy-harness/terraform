terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 2.13.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "docker" {

}
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
provider "google" {
  project     = "sales-209522"
  region      = "us-central1"
}
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0279c3b3186e54acd"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

  access_config {
    // Ephemeral public IP
  }
}
}