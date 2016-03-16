resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "k8s bastion security group"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress = {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "${ var.cidr-allow-ssh }" ]
  }

  tags {
    // KubernetesCluster = "${ var.cluster-id }"
    Cluster = "${ var.name }"
    Name = "bastion"
    builtWith = "terraform"
  }

  vpc_id = "${ var.vpc-id }"
}

resource "aws_security_group" "etcd" {
  name = "etcd"
  description = "k8s etcd security group"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    /*self = true*/
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
    cidr_blocks = [ "${ var.cidr-vpc }" ]
  }

  tags {
    KubernetesCluster = "${ var.cluster-id }"
    Cluster = "${ var.name }"
    Name = "etcd"
    builtWith = "terraform"
  }

  vpc_id = "${ var.vpc-id }"
}

resource "aws_security_group" "external-elb" {
  name = "master-external-elb"
  description = "k8s master (apiserver) external elb"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    /*cidr_blocks = [ "${ var.cidr-vpc }" ]*/
    security_groups = [ "${ aws_security_group.etcd.id }" ]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags {
    KubernetesCluster = "${ var.cluster-id }"
    Cluster = "${ var.name }"
    Name = "master-external-elb"
    builtWith = "terraform"
  }

  vpc_id = "${ var.vpc-id }"
}

resource "aws_security_group" "worker" {
  name = "worker"
  description = "k8s worker security group"

  egress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    /*self = true*/
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress = {
    from_port = 0
    to_port = 0
    protocol = "-1"
    self = true
    cidr_blocks = [ "${ var.cidr-vpc }" ]
  }

  tags {
    KubernetesCluster = "${ var.cluster-id }"
    Cluster = "${ var.name }"
    Name = "worker"
    builtWith = "terraform"
  }

  vpc_id = "${ var.vpc-id }"
}
