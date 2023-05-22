resource "openstack_compute_keypair_v2" "key" {
  name       = "gavrilov_ai_app"
  public_key = "ssh-ed25519 AAAA..."
}

resource "openstack_networking_secgroup_v2" "secgroup" {
  name        = "gavrilov_secgroup_app"
  description = "WebApp SecurityGroup"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup-rule-1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup-rule-2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgroup.id}"
}

resource "openstack_compute_instance_v2" "node" {
  name            = "gavrilov_app"
  image_name      = "ubuntu-20.04"
  flavor_name     = "m1.small"
  key_pair        = "${openstack_compute_keypair_v2.key.name}"
  security_groups = [
    "students-general", 
    "${openstack_networking_secgroup_v2.secgroup.name}"
  ]
 
  network {
    name = "sutdents-net"
  }
}
