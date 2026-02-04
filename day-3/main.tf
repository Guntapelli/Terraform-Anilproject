resource "aws_vpc" "name" {
    region = "us-east-1"
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "terraform"
    }
  
}
  
resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name= "Kumar"
    }
  
}
resource "aws_subnet" "name1" {
    vpc_id = aws_vpc.name.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name="Kumar1"
    }
}

resource "aws_internet_gateway" "name" {
    vpc_id = aws_vpc.name.id
    tags = {
      Name="IG"
    }

  
}
resource "aws_route_table" "name" {
    vpc_id = aws_vpc.name.id
    route {
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.name.id
}

}
resource "aws_route_table" "name1" {
    vpc_id = aws_vpc.name.id
route {
  cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.name.id
}

  
}
resource "aws_route_table_association" "name" {
    subnet_id = aws_subnet.name.id
    route_table_id = aws_route_table.name.id

  
}
resource "aws_route_table_association" "name1" {
    subnet_id = aws_subnet.name1.id
    route_table_id = aws_route_table.name1.id
  
}
resource "aws_security_group" "allow_tls" {
    name = "allow_tls"
    vpc_id = aws_vpc.name.id
    tags = {
      name="ranganayaka"

    }
ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
}
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" #all protocols 
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  
}
resource "aws_eip" "name" {
    tags={
        Name="nat_eip"
    }
}
resource "aws_nat_gateway" "name" {
    allocation_id = aws_eip.name.id
    subnet_id = aws_subnet.name.id
    tags ={
        Name= "kg-gate"
         }
  
}
resource "aws_instance" "name" {
    ami="ami-0532be01f26a3de55"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name.id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
 
}
resource "aws_instance" "name1" {
    ami = "ami-0532be01f26a3de55" 
    instance_type = "t3.micro"
    subnet_id = aws_subnet.name1.id
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
     
}


