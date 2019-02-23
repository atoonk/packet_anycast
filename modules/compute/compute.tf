# Andree Toonk
# Feb 23, 2019

variable facility { }
variable project_id { }
variable compute_count { }
variable operating_system { }
variable instance_type { }
variable anycast_ip { }
#variable bgp_password { }

resource "packet_bgp_session" "test" {
    count          = "${var.compute_count}"
    device_id      = "${packet_device.compute-server.*.id[count.index]}"
    address_family = "ipv4"
}

resource "packet_device" "compute-server" {
    hostname 	     = "${format("compute-%03d", count.index)}.${var.facility}"
    count            = "${var.compute_count}"
    plan             = "${var.instance_type}"
    facilities         = ["${var.facility}"]
    operating_system = "${var.operating_system}" 
    billing_cycle    = "hourly"
    project_id       = "${var.project_id}"

    provisioner "local-exec" {
	command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null scripts/create_bird_conf.sh root@${self.access_public_ipv4}:/root/create_bird_conf.sh"
    }
    provisioner "local-exec" {
	command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null scripts/web.go root@${self.access_public_ipv4}:/root/web.go"
    }
    provisioner "local-exec" {
	command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null scripts/start.sh root@${self.access_public_ipv4}:/root/start.sh"
    }
    provisioner "local-exec" {
	command = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  root@${self.access_public_ipv4} 'bash /root/start.sh ${var.anycast_ip}  > /dev/null 2>&1 '"
    }
}
