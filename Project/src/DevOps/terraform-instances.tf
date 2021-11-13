resource "aws_key_pair" "keypair" {
  key_name   = "keypair-agisit"
  public_key = file("${path.module}/keypair/agisit.pub")
}

resource "aws_instance" "frontend" {
  ami           = var.ami
  instance_type = var.instance_type
  private_ip    = "10.0.0.50"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.keypair.key_name

  vpc_security_group_ids = [
    aws_security_group.security_group_http_https.id,
    aws_security_group.security_group_ssh_icmp.id,
    aws_security_group.security_group_nodejs.id,
    aws_security_group.security_group_node_exporter.id
  ]

  tags = {
    Name = "frontend"
  }
}

resource "aws_instance" "servers" {
  ami           = var.ami
  count         = 4
  instance_type = var.instance_type
  private_ip    = "10.0.1.5${count.index + 1}"
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = aws_key_pair.keypair.key_name

  vpc_security_group_ids = [
    aws_security_group.security_group_ssh_icmp.id,
    aws_security_group.security_group_nodejs.id,
    aws_security_group.security_group_node_exporter.id
  ]

  tags = {
    Name = "servers[${count.index + 1}]"
  }
}

resource "aws_instance" "monitor" {
  ami           = var.ami
  instance_type = var.instance_type
  private_ip    = "10.0.0.51"
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = aws_key_pair.keypair.key_name

  vpc_security_group_ids = [
    aws_security_group.security_group_http_https.id,
    aws_security_group.security_group_ssh_icmp.id,
    aws_security_group.security_group_grafana_prometheus.id
  ]

  tags = {
    Name = "monitor"
  }
}
