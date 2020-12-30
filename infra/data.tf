
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }


  owners = ["099720109477"] # Canonical
}

data "aws_subnet_ids" "get_public_subnet_ids" {
  vpc_id = aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["Test_VPC_public_subnet"]
  }

  filter {
    name = "availability-zone"
    values = [ "us-east-1a"]
  }
}

data "aws_subnet_ids" "get_private_subnet_ids" {
  vpc_id = aws_vpc.vpc.id
  filter {
    name   = "tag:Name"
    values = ["Test_VPC_private_subnet"]
  }

  filter {
    name = "availability-zone"
    values = [ "us-east-1a"]
  }
}