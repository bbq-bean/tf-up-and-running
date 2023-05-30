resource "aws_security_group" "instance-sg" {
    name = "tf-example-instance"
    ingress {
        to_port = 8080
        from_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "example" {
    ami = "ami-0062dbf6b829f04e1"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.instance-sg.id]
    user_data = <<-EOF
                #!/bin/bash
                echo "Hello World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
    tags = {
        auto-delete = "no"
    }
}

