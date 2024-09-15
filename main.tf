
provider "aws" {
  region  = "ap-south-1"  # AWS region where resources will be deployed
}

# Fetch the existing VPC
data "aws_vpc" "existing_vpc" {
  id = "vpc-0edf9b3c6398c27d2"  # Replace with your existing VPC ID
}

# Fetch the existing public subnet
data "aws_subnet" "public_subnet_1" {
  id = "subnet-01f857f124f0f716c"  # Replace with your existing Public Subnet ID
}

# Fetch the existing public subnet
data "aws_subnet" "public_subnet_2" {
  id = "subnet-0f6ba87642ea02c34"  # Replace with your existing Public Subnet ID
}

# Fetch the existing private subnet (for RDS)
data "aws_subnet" "private_subnet" {
  id = "subnet-047b5451584742425"  # Replace with your existing Private Subnet ID
}

# Fetch the existing EC2 instance
data "aws_instance" "existing_web_server_1" {
  instance_id = "i-0afa856aeec471ac6"  # Replace with your existing EC2 instance ID
}

# Fetch the existing EC2 instance
data "aws_instance" "existing_web_server_2" {
  instance_id = "i-02aa7c4d6489b7ec8"  # Replace with your existing EC2 instance ID
}

# Fetch the existing EC2 instance
data "aws_instance" "existing_web_server_3" {
  instance_id = "i-02301ca039d67d1f5"  # Replace with your existing EC2 instance ID
}

# Fetch the existing RDS instance
#data "aws_db_instance" "existing_rds" {
#  db_instance_identifier = "cloudcrew-rds-database"  # Replace with your existing RDS instance identifier
#}

# Fetch the existing S3 bucket
data "aws_s3_bucket" "existing_website_bucket" {
  bucket = "cloud-crew-static"  # Replace with your existing S3 bucket name
}

# Create an S3 bucket to store Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket_prefix = "my-terraform-state-"  # Unique prefix for bucket name
  acl           = "private"

  tags = {
    Name = "terraform-state-bucket"
  }
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "terraform-lock-table"
  }
}
