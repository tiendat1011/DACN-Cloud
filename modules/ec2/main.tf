provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_key_pair" "my_key" {
  key_name   = var.key_name
  public_key = var.public_key_path
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