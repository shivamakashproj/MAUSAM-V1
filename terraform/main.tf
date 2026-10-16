
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_key_pair" "mausam" {
  key_name = var.key_name
}

resource "aws_security_group" "mausam" {
  name        = "${var.project_name}-sg"
  description = "Security group for MAUSAM EC2"
  vpc_id      = data.aws_vpc.default.id

  # Required by current GitHub Actions SSH workflow.
  # Security risk: SSH reachable from any IPv4 address.
  ingress {
    description = "SSH for GitHub Actions deployment"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "MAUSAM web application"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "mausam" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  key_name                    = data.aws_key_pair.mausam.key_name
  vpc_security_group_ids      = [aws_security_group.mausam.id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/user_data.sh", {
    docker_image = var.docker_image
  })

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = var.project_name
  }
}
