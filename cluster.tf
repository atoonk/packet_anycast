# Andree Toonk
# Feb 23, 2019

provider "packet" {
    auth_token = "${var.packet_api_key}"
}

# Create project

resource "packet_project" "anycast_test" {
    name = "anycast project"
    bgp_config {
        deployment_type = "local"
        #md5 = "${var.bgp_password}"
        asn = 65000
    }
}

# Create a Global IPv4 IP to be used for Anycast
# the Actual Ip is available as: packet_reserved_ip_block.anycast_ip.address
# We'll pass that along to each compute node, so they can assign it to all nodes and announce it in BGP

resource "packet_reserved_ip_block" "anycast_ip" {
    project_id = "${packet_project.anycast_test.id}"
    type     = "global_ipv4"
    quantity = 1
}

module "compute_sjc" {
  source = "./modules/compute"
  project_id = "${packet_project.anycast_test.id}"
  anycast_ip = "${packet_reserved_ip_block.anycast_ip.address}"
  operating_system = "ubuntu_18_04"
  instance_type = "baremetal_0"
  facility = "sjc1"
  compute_count = "2"
}

module "compute_nrt" {
  source = "./modules/compute"
  project_id = "${packet_project.anycast_test.id}"
  anycast_ip = "${packet_reserved_ip_block.anycast_ip.address}"
  operating_system = "ubuntu_18_04"
  instance_type = "baremetal_0"
  facility = "nrt1"
  compute_count = "2"
}

module "compute_ams" {
  source = "./modules/compute"
  project_id = "${packet_project.anycast_test.id}"
  anycast_ip = "${packet_reserved_ip_block.anycast_ip.address}"
  operating_system = "ubuntu_18_04"
  instance_type = "baremetal_0"
  facility = "ams1"
  compute_count = "2"
}

module "compute_ewr" {
  source = "./modules/compute"
  project_id = "${packet_project.anycast_test.id}"
  anycast_ip = "${packet_reserved_ip_block.anycast_ip.address}"
  operating_system = "ubuntu_18_04"
  instance_type = "baremetal_0"
  facility = "ewr1"
  compute_count = "2"
}


