resource "aws_security_group" "ingress_sg" {
  name_prefix = "ingress_sg"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "ingress_sg"
  }
}


resource "aws_security_group_rule" "ingress_my_machine" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["**.**.194.240/32"]
  security_group_id = aws_security_group.ingress_sg.id

}


resource "aws_security_group_rule" "internet_outbound" {
  provider          = aws
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ingress_sg.id
  description       = "Internet outbound"
}
