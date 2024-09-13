provider "aws" {
  region  = "ap-south-1"  # Replace with your desired AWS region
  # You can add more configuration options here if needed
}


# Fetch details of an existing VPC by ID
data "aws_vpc" "existing" {
  id = "vpc-0edf9b3c6398c27d2"  # Replace with your VPC ID
}

# Fetch details of an existing subnet by ID
data "aws_subnet" "existing_subnet_pub_1" {
  id = "subnet-01f857f124f0f716c"  # Replace with your Subnet ID
}

# Fetch details of an existing subnet by ID
data "aws_subnet" "existing_subnet_pub_2" {
  id = "subnet-0f6ba87642ea02c34"  # Replace with your Subnet ID
}

# Fetch details of an existing subnet by ID
data "aws_subnet" "existing_subnet_pvt" {
  id = "subnet-047b5451584742425"  # Replace with your Subnet ID
}

# Fetch details of an existing security group by ID
data "aws_security_group" "existing_sg" {
  id = "sg-001a10ccf61956502"  # Replace with your Security Group ID
}

# Fetch details of an existing security group by ID
data "aws_security_group" "Cloudcrew-EC2-Instance-1" {
  id = "sg-0ee13bab74f9f2682"  # Replace with your Security Group ID
}

# Example: Launch an EC2 instance in the existing VPC
resource "aws_instance" "web_server" {
  ami           = "ami-0888ba30fd446b771"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet_pub_2.id
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "web-server"
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0888ba30fd446b771"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet_pub_2.id
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "check-terraform_1"
  }
}
resource "aws_instance" "web_server" {
  ami           = "ami-0888ba30fd446b771"  # Replace with a valid AMI ID
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.existing_subnet_pub_2.id
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]

  tags = {
    Name = "check-terraform_new"
  }
}
