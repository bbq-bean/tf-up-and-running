# export TF_VAR_app_environment="production"
variable "app_environment" {
    description = "should be production or staging"
    type = string
    default = "dev"
}

resource "aws_security_group" "instance-sg-example" {
    # Security group name in EC2
    name = "allow 8080 from VPC range"
    ingress {
        to_port = 8080
        from_port = 8080
        protocol = "tcp"
        cidr_blocks = ["172.31.0.0/16"]
    }
    # tf removes the default allow all outbound traffic rule, this adds it back
    egress { 
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }
    tags = {
        environment = var.app_environment
    }
}

resource "aws_instance" "example-ec2-instance" {
    ami = "ami-01138e8a57f052350"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.instance-sg-example.id, "sg-0622ef70d84b77b30"]
    key_name = "jkerr_desktop_2"
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    tags = {
        Name = "terraform-example-instance"
        environment = var.app_environment
    }
}

