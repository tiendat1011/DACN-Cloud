provider "aws" {
  region = "ap-southeast-2"
  # access_key = var.access_key
  # secret_key = var.secret_key
}

resource "aws_key_pair" "my_key" {
  key_name   = var.key_name
  public_key = var.public_key_path
}

resource "aws_security_group" "allow_all" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance_1" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_1_id
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  key_name = aws_key_pair.my_key.key_name

  tags = {
    Name = "Instance 1"
  }
}

resource "aws_instance" "instance_2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_2_id
  vpc_security_group_ids = [aws_security_group.allow_all.id]

  key_name = aws_key_pair.my_key.key_name

  tags = {
    Name = "Instance 2"
  }
}

resource "aws_eip" "eip_1" {
  instance = aws_instance.instance_1.id
}

resource "aws_eip" "eip_2" {
  instance = aws_instance.instance_2.id
}