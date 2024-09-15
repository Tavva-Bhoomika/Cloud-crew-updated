# Backend configuration to store Terraform state in S3
terraform {
  backend "s3" {
    bucket         = aws_s3_bucket.terraform_state_bucket.id  # Referencing the S3 bucket created by Terraform
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = aws_dynamodb_table.terraform_locks.name  # DynamoDB table for state locking
  }
}

provider "aws" {
  region  = "ap-south-1"  # AWS region where resources will be deployed
}

# Create an S3 bucket for storing Terraform state
resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = "my-unique-terraform-state-bucket"  # Replace with a globally unique bucket name
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}

# Enable server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform Lock Table"
  }
}

# Fetch details of an existing VPC by ID
data "aws_vpc" "existing" {
  id = "vpc-0edf9b3c6398c27d2"  # Replace with your VPC ID
}

# Fetch details of existing subnets by IDs
data "aws_subnet" "existing_subnet_pub_1" {
  id = "subnet-01f857f124f0f716c"  # Replace with your Subnet ID
}

data "aws_subnet" "existing_subnet_pub_2" {
  id = "subnet-0f6ba87642ea02c34"  # Replace with your Subnet ID
}

data "aws_subnet" "existing_subnet_pvt" {
  id = "subnet-047b5451584742425"  # Replace with your Subnet ID
}

# Fetch details of an existing security group by ID
data "aws_security_group" "existing_sg" {
  id = "sg-001a10ccf61956502"  # Replace with your Security Group ID
}

# Launch an EC2 instance in the existing VPC and subnet
resource "aws_instance" "web_server" {
  ami           = "ami-0888ba30fd446b771"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet_pub_2.id
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "web_servernew1" {
  ami           = "ami-0888ba30fd446b771"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet_pub_2.id
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "web-servernew1"
  }
}
