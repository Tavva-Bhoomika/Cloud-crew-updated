# Configure Terraform to store state in an S3 bucket and use DynamoDB for locking
terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-state-bucket"  # Replace with a unique S3 bucket name
    key            = "terraform.tfstate"
    region         = "ap-south-1"  # Region where your S3 bucket is created
    encrypt        = true
    dynamodb_table = "terraform-locks"  # Optional: DynamoDB table for state locking
  }
}

# Provider configuration
provider "aws" {
  region = "ap-south-1"  # Replace with your desired AWS region
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

# Launch an EC2 instance in the existing VPC and Subnets
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

# Optional: DynamoDB table for state locking to ensure safe concurrent updates
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
