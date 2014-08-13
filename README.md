terraform_inventory [![Build Status](https://travis-ci.org/bandwidthcom/terraform-inventory.svg)](https://travis-ci.org/bandwidthcom/terraform-inventory)
=========

Create an Ansible inventory file from a Terraform state file.

The main objective of this tool is to be able to select whatever resources you need in Terraform state and build an Ansible inventory file. This should be possible without changing a Terraform plan by only relying on the output of ```terraform show```. It must be possible to place a resource in multiple host groups.

This mostly makes sense with the following resources since we are targetting Ansible:
- [aws_instance](http://www.terraform.io/docs/providers/aws/r/instance.html)
- [digitalocean_droplet](http://www.terraform.io/docs/providers/do/r/droplet.html) (not supported yet)

#### Example
```
tinventory --map=aws_instance.web:web aws_instance.web.0:blog aws_instance.web.1:api ./inventory
```
Translation:
- Put all aws_instance resources named web in the web host group of the inventory file
- Put the first aws_instance resource named web in the blog host group of the inventory file
- Put the second aws_instance resource named web in the api host group of the inventory file
- The inventory file is called "./inventory"

This scenario demonstrates that you can select resources from Terraform state and put the resulting resources in a specific host group of the Ansible inventory file.

#### Commands
Options:
  - --map=resource_selector:host_group (required)
    - Maps between Terraform resource selector and Ansible host group.
    - The "none" host group puts the hosts IP address at the top of the file without a group
  - --state=<path to state file> (optional)
    - Path to a Terraform state file.
    - Default: /home/tyler/Projects/terraform_inventory/terraform.tfstate
