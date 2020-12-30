resource "aws_instance" "web" {
 
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name = "TestTtgw"
  associate_public_ip_address = true
  security_groups = [aws_security_group.ingress_sg.id]
  subnet_id = data.aws_subnet_ids.get_public_subnet_ids.ids
  tags = {
    Name = "Seclore_test_web_public"
  }
}
