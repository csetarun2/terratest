terraform {
  # This module is now only being tested with Terraform 0.13.x. However, to make upgrading easier, we are setting
  # 0.12.26 as the minimum version, as that version added support for required_providers with source URLs, making it
  # forwards compatible with 0.13.x code.
  required_version = ">= 0.12.26"
}

provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAZPPPHX5VIJY3TOE4"
  secret_key = "zpbDTHX+TAwWWlLBpALUzw86ZCknl"
}

# website::tag::1:: Deploy an EC2 Instance.
resource "aws_instance" "example" {
  # website::tag::2:: Run an Ubuntu 18.04 AMI on the EC2 instance.
  ami                    = "ami-01aab85a5e4a5a0fe"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  # website::tag::3:: When the instance boots, start a web server on port 808 that responds with "Hello, World!".
  user_data = <<EOF
#!/bin/bash
yum update -y
yum install httpd -y
echo "Hello, World!" >> /var/www/html/index.html
systemctl  start httpd
EOF
}

# website::tag::4:: Allow the instance to receive requests on port 8080.
resource "aws_security_group" "instance" {
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
    ingress {
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
  
}

# website::tag::5:: Output the instance's public IP address.
output "public_ip" {
  value = aws_instance.example.public_ip
}
