source "googlecompute" "web-vm-image" {
  project_id = "eternal-wavelet-301417"
  source_image = "centos-8-v20210316"
  ssh_username = "packer"
  zone = "us-central1-a"
  image_family = "centos-8"
  image_name = "web-vm-image"
  image_description = "Image for Web VMs"
}

build {
  sources = ["sources.googlecompute.web-vm-image"]
}