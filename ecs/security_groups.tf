

resource "aws_security_group" "ALB-SG" {
  name        = "${local.name}-Loadbalancer-SG"
  description = "Application load balancer allows traffic in via port 80 and 443"
    vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description      = "allows http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
    # ipv6_cidr_blocks = [data.aws_vpc.vpc.ipv6_cidr_block]
  }
  
  ingress {
    description      = "allows https traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    # cidr_blocks      = [data.aws_vpc.vpc.cidr_block]
    # ipv6_cidr_blocks = [data.aws_vpc.vpc.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.name}-Loadbalancer-SG"
  }

}

resource "aws_security_group" "ECS-SG" {
    name = "${local.name}-ECS-SG"
    description = "ECS security groups"
    vpc_id      = data.aws_vpc.vpc.id

    ingress {
        description = "HTTP Traffic"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        security_groups = [aws_security_group.ALB-SG.id]
    }

    ingress {
        description = "SSH Traffic"
        from_port   = 22
        to_port     = 22
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
        Name = "${local.name}-ECS-SG"
    }

}

#Secuirty Groups
resource "aws_security_group" "EFS_SG" {
    name = "${local.name}-EFS-SG"
    description = "EFS security groups"
    vpc_id      = data.aws_vpc.vpc.id

    ingress {
        description = "Allows efs traffic from "
        from_port   = 2049
        to_port     = 2049
        protocol    = "tcp"
        security_groups = [aws_security_group.ECS-SG.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
    

    tags = {
        Name = "${local.name}-EFS-SG"
    }

}

