provider "aws" {
  region  = "ap-south-1"  # AWS region where resources will be deployed
}

# Fetch the existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0edf9b3c6398c27d2"  # Replace with your existing VPC ID
}

# Fetch existing public subnets
data "aws_subnet" "public_subnet_1" {
  id = "subnet-01f857f124f0f716c"  # Replace with your existing Public Subnet ID
}

data "aws_subnet" "public_subnet_2" {
  id = "subnet-0f6ba87642ea02c34"  # Replace with your existing Public Subnet ID
}

# Fetch the existing private subnet (for RDS)
data "aws_subnet" "private_subnet" {
  id = "subnet-047b5451584742425"  # Replace with your existing Private Subnet ID
}

# Fetch existing EC2 instances
data "aws_instance" "existing_web_server_1" {
  instance_id = "i-0afa856aeec471ac6"  # Replace with your existing EC2 instance ID
}

data "aws_instance" "existing_web_server_2" {
  instance_id = "i-0c7f387d9fe0fb709"  # Replace with your existing EC2 instance ID
}

data "aws_instance" "existing_web_server_3" {
  instance_id = "i-075fb35c736aa1fef"  # Replace with your existing EC2 instance ID
}

data "aws_instance" "existing_web_server_4" {
  instance_id = "i-01453300c100fa958"  # Replace with your existing EC2 instance ID
}

# Fetch existing S3 buckets
data "aws_s3_bucket" "existing_website_bucket" {
  bucket = "cloud-crew-static"  # Replace with your existing S3 bucket name
}

data "aws_s3_bucket" "existing_website_bucket1" {
  bucket = "cloudcrew-cloudfront-logs"  # Replace with your existing S3 bucket name
}

# Fetch existing IAM roles
data "aws_iam_role" "existing_ec2_role1" {
  name = "alarm-role"  # Replace with your existing EC2 role name
}

data "aws_iam_role" "existing_ec2_role2" {
  name = "ec2-access"  # Replace with your existing EC2 role name
}

data "aws_iam_role" "existing_ec2_role3" {
  name = "rds-monitoring-role"  # Replace with your existing EC2 role name
}

# Create an S3 bucket to store Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket_prefix = "my-terraform-state-"  # Unique prefix for bucket name
  acl           = "private"

  tags = {
    Name = "terraform-state-bucket"
  }
}

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-20240915102923120200000001"  # Replace with your S3 bucket name
    key            = "terraform/state/terraform.tfstate"  # Path within the bucket to store the state file
    region         = "ap-south-1"  # Replace with your AWS region
  }
}

# Example: Create a new EC2 instance
resource "aws_instance" "new_web_server" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public_subnet_1.id  # Use existing public subnet
  key_name               = "my-key-pair"  # Replace with your existing key pair name

  tags = {
    Name = "NewWebServer"
  }

  # User data to install Apache on EC2 instance
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Welcome to New Web Server deployed by Terraform</h1>" | sudo tee /var/www/html/index.html
              EOF
}

# Example: Create a Security Group
resource "aws_security_group" "allow_ssh_http" {
  vpc_id = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere (you may restrict this)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

# Attach Security Group to the new EC2 instance
resource "aws_instance" "new_ec2_instance" {
  ami                    = "ami-0c55b159cbfafe1f0"  # Replace with appropriate AMI ID
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.public_subnet_1.id
  key_name               = "my-key-pair"  # Replace with your key pair name
  security_groups        = [aws_security_group.allow_ssh_http.name]

  tags = {
    Name = "NewEC2Instance"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              echo "<h1>Hello, from Terraform EC2 instance</h1>" | sudo tee /var/www/html/index.html
              EOF
}

# Output the new EC2 instance's public IP
output "ec2_public_ip" {
  value = aws_instance.new_ec2_instance.public_ip
}
