
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
  instance_id = "i-0c7f387d9fe0fb709"  # Replace with your existing EC2 instance ID
}

# Fetch the existing EC2 instance
data "aws_instance" "existing_web_server_3" {
  instance_id = "i-075fb35c736aa1fef"  # Replace with your existing EC2 instance ID
}

# Fetch the existing EC2 instance
data "aws_instance" "existing_web_server_4" {
  instance_id = "i-01453300c100fa958"  # Replace with your existing EC2 instance ID
}

resource "aws_db_instance" "example" {
  identifier              = "cloudcrew-rds-database-instance-1"
  instance_class          = "db.t3.medium"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.05.2"
  allocated_storage       = 1
  db_subnet_group_name    = "default-vpc-0edf9b3c6398c27d2"
  db_name                 = "your-database-name" # Specify if applicable
  username                = "admin"
  password                = "your-password" # Use sensitive values or environment variables
  parameter_group_name    = "default.aurora-mysql8.0"
  backup_retention_period = 1
  preferred_backup_window = "21:53-22:23"
  preferred_maintenance_window = "thu:12:02-thu:12:32"
  multi_az                = false
  auto_minor_version_upgrade = true
  publicly_accessible     = false
  storage_type            = "aurora"
  db_cluster_identifier   = "cloudcrew-rds-database"
  storage_encrypted       = true
  kms_key_id              = "arn:aws:kms:ap-south-1:026090544238:key/4b06577d-d3fe-4f97-b312-636fa03df05b"
  ca_certificate_identifier = "rds-ca-rsa2048-g1"
  delete_automated_backups = false
  copy_tags_to_snapshot   = false
  monitoring_interval     = 0
  promotion_tier          = 1
  db_instance_arn         = "arn:aws:rds:ap-south-1:026090544238:db:cloudcrew-rds-database-instance-1"
  iam_database_authentication_enabled = false
  performance_insights_enabled = false
  deletion_protection     = false
  customer_owned_ip_enabled = false
  network_type            = "IPV4"
  storage_throughput      = 0
  dedicated_log_volume   = false

  vpc_security_group_ids = [
    "sg-0c3161c9a134f3a6f",
    "sg-0491ee7e2bc459e4a"
  ]

  tags = {
    Name = "cloudcrew-rds-database-instance-1"
  }
}

resource "aws_db_subnet_group" "example" {
  name        = "default-vpc-0edf9b3c6398c27d2"
  description = "Created from the RDS Management Console"
  subnet_ids  = [
    "subnet-0f6ba87642ea02c34",
    "subnet-047b5451584742425",
    "subnet-01f857f124f0f716c"
  ]
}

output "db_instance_endpoint" {
  value = aws_db_instance.example.endpoint
}

output "db_instance_arn" {
  value = aws_db_instance.example.arn
}

# Fetch the existing S3 bucket
data "aws_s3_bucket" "existing_website_bucket" {
  bucket = "cloud-crew-static"  # Replace with your existing S3 bucket name
}

# Fetch the existing S3 bucket
data "aws_s3_bucket" "existing_website_bucket1" {
  bucket = "cloudcrew-cloudfront-logs"  # Replace with your existing S3 bucket name
}

# Fetch the existing IAM role
data "aws_iam_role" "existing_ec2_role1" {
  name = "alarm-role"  # Replace with your existing EC2 role name
}
# Fetch the existing IAM role
data "aws_iam_role" "existing_ec2_role2" {
  name = "ec2-access"  # Replace with your existing EC2 role name
}
# Fetch the existing IAM role
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
