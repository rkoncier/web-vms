# Project: web-vms
This project is a test project to provision bunch of VMs in Google Cloud with WEB server running on default http port.

## Project Description:
Project has two logical parts:
  - Create custom CentOS VM image with Flask web framework running custom index page.
  - Provision group of VM instances (default 4) based on custom CentOS VM image and load balance instances to public IP address.

## List of tools:
  - **Docker** - provision local toolset: [Dockerfile](Dockerfile) container to execute Hashicorp Packer tool build VM image with help of Ansible builder playbook; [Dockerfile.terr](Dockerfile.terr) container to execute Hashicorp Terraform scripts to provision/destroy topology
  - **Hashicorp Packer** - create custom CentOS VM image in Google Could [image.pkr.hcl](image/image.pkr.hcl)
  - **Ansible** - configure custom CentOS VM image and install required applications (Nginx, Flask) [Ansible playbook](image/playbook.yml)
  - **Nginx** - VM internal ingress controller, publishing services to default HTTP port
  - **Flask** - Web framework tu publish very simple http response with details about VM instance
  - **Hashicorp Terraform** - provision topology resources in Google Cloud; [main script](topology/main.tf)
  - **Google Cloud** - cloud provider to store/run resources
  
## List of required features, and their implementation in project:
  - _Create a few virtual machines_ - by default Terraform provisions 4 VM instances, this can be changed in variable [size_default](topology/variables.tf)
  - _each with a webserver running_ - as a webserver was used Flask (not fully powered webserver but enough for this project)
  - _that is accessible only to the other machines in the test pool_ - group VM instances are created in separated VPC (Virtual private cloud) with separated sub-network and firewall rules only get access to ports HTTP/80 and SSH/22
  - _Only the ports that are required to hosts and communicate with the webserver should be open on the virtual machines._ - _http_ and _ssh_ services are enabled in _public_ zone and _public_ zone is set as a default for firewalld service [Ansible playbook](image/playbook.yml)
  - _The root URL on each webserver should return a simple informational page that displays the current operating system version, date, time and IP address._ - Flask web framework on every VM instances runs Python code showing required VM details, code can be modified in [app.py](src/app.py) file and custom image can be regenerated.
  - _This small proof of concept solution should be able to scale out across many more machines, with minimal human iteration._ - group of VM instances is possible manually rescale using Terraform script with modified `size_deafult` variable or using Google Cloud portal (or there is also option to use auto-rescale triggered by CPU utilization ..)

## Duration of execution:
  - [build_image.sh](build_image.sh) - 3 mins
  - [provision_topology.sh](provision_topology.sh) - 3 mins
  - [destroy_topology.sh](destroy_topology.sh) - 2 mins