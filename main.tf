resource "aws_vpc" "hon-practise-vpc" {
    cidr_block = "10.0.0.0/16"
    region = var.region
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "hon-practise-vpc"
    }
}


resource "aws_subnet" "hon-practise-subnet-public" {
    vpc_id = aws_vpc.hon-practise-vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.region}a"
    map_public_ip_on_launch = true
    tags = {
        Name = "hon-practise-subnet-public"
    }
}

resource "aws_subnet" "hon-practise-subnet-private" {
    vpc_id = aws_vpc.hon-practise-vpc.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.region}a"
    tags = {
        Name = "hon-practise-subnet-private"
    }
}

resource "aws_internet_gateway" "hon-practise-igw" {
    vpc_id = aws_vpc.hon-practise-vpc.id
    tags = {
        Name = "hon-practise-igw"
    }
}

resource "aws_eip" "nat-gw-eip" {

}

resource "aws_nat_gateway" "hon-practise-nat-gw" {
    allocation_id = aws_eip.nat-gw-eip.id
    subnet_id = aws_subnet.hon-practise-subnet-public.id
    depends_on = [aws_internet_gateway.hon-practise-igw ]
    tags = {
        Name = "hon-practise-nat-gw"
    }
}


resource "aws_route_table" "hon-practise-rt-public" {
    vpc_id = aws_vpc.hon-practise-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.hon-practise-igw.id
    }
    tags = {
        Name = "hon-practise-rt"
    }
}


resource "aws_route_table" "hon-practise-rt-private" {
    vpc_id = aws_vpc.hon-practise-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.hon-practise-nat-gw.id
    }
    tags = {
        Name = "hon-practise-rt-private"
    }
}


resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.hon-practise-subnet-public.id
    route_table_id = aws_route_table.hon-practise-rt-public.id
  
}

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.hon-practise-subnet-private.id
    route_table_id = aws_route_table.hon-practise-rt-private.id
}

resource "aws_security_group" "public" {
    name = "hon-practise-sg-public"
    description = "Use for public subnet to allow all inbound and outbound traffic"
    vpc_id = aws_vpc.hon-practise-vpc.id

    
  
}

resource "aws_vpc_security_group_ingress_rule" "public_inbound" {
    security_group_id = aws_security_group.public.id
    description = "Allow all inbound traffic for public subnet"
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "public_outbound" {
  security_group_id = aws_security_group.public.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"  # all traffic
}


resource "aws_security_group" "private" {
    name = "hon-practise-sg-private"
    description = "Use for private subnet to allow all outbound traffic and only allow inbound traffic from public subnet"
    vpc_id = aws_vpc.hon-practise-vpc.id

}

resource "aws_vpc_security_group_ingress_rule" "private_inbound" {
    security_group_id = aws_security_group.private.id
    description = "Allow inbound traffic from public subnet for private subnet"
    ip_protocol = "-1"
    cidr_ipv4 = aws_subnet.hon-practise-subnet-public.cidr_block
}


resource "aws_vpc_security_group_egress_rule" "private_outbound" {
    security_group_id = aws_security_group.private.id
    description = "Allow all outbound traffic for private subnet"
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
}


resource "aws_instance" "hon-practise-instance" {
    ami = data.aws_ami.latest.id
    instance_type = "t3.medium"
    subnet_id = aws_subnet.hon-practise-subnet-public.id
    vpc_security_group_ids = [aws_security_group.public.id]
    key_name = data.aws_key_pair.example.key_name
    user_data = file("./userdata.sh")

    tags = {
        Name = "hon-practise-instance"
    }
}
