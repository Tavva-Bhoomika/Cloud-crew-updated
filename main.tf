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

resource "aws_s3_bucket" "my_bucket" {
  bucket = "cloud-crew-staticwebsite"  # Replace with your unique bucket name

  # Enable versioning for the bucket
  versioning {
    enabled = true
  }

  # Define bucket-level tags
  tags = {
    Name        = "MyS3Bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_public_access_block" "my_bucket_access_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.my_bucket.arn}/*",
        Condition = {
          IpAddress = {
            "aws:SourceIp": "203.0.113.0/24"  # Replace with the IP address or range you want to allow
          }
        }
      }
    ]
  })
}

# Define a separate bucket for logging
resource "aws_s3_bucket" "logging_bucket" {
  bucket = "cloud-crew-logging-bucket"  # Replace with a unique name for the logging bucket

  # Enable versioning for the bucket
  versioning {
    enabled = true
  }

  # Define bucket-level tags
  tags = {
    Name = "LoggingBucket"
  }
}

data "aws_s3_bucket" "existing_website_bucket1" {
  bucket = "clowcrew-logs"  # Replace with your existing S3 bucket name
}

data "aws_s3_bucket" "existing_website_bucket2" {
  bucket = "cloudcrew-rds-backup"  # Replace with your existing S3 bucket name
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
resource "aws_s3_bucket_public_access_block" "my_bucket_access_block1" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Fetch existing security group by name
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["sonarqube"]  # Replace with your existing security group name
  }
  vpc_id = data.aws_vpc.existing_vpc.id  # Ensure it matches the VPC of the security group
}

