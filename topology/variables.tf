variable "size_default" {
  type = number
  default = 4
  description = "The default size of group."
}

variable "project" {
  type = string
  default = "eternal-wavelet-301417"
  description = "The project ID"
}

variable "region" {
  type = string
  default = "us-central1"
  description = "Google region"
}

variable "zone" {
  type = string
  default = "us-central1-c"
  description = "Google zone"
}

variable "subnetwork_range" {
  type = string
  default = "192.168.10.0/24"
  description = "The sub-network Ip addresses range"
}

variable "ingress_ports" {
  type = list(string)
  default = ["80","22"]
  description = "The list of sub-network ingress ports"
}

variable "compute_size" {
  type = string
  default = "e2-micro"
  description = "The compute resource size"
}

variable "service_port" {
  type = string
  default = 80
  description = "The default service port"
}