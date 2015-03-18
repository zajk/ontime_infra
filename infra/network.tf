resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.main.id}"

    tags {
        Name = "VPC Internet gateway"
    }
}

# Availability zone A subnets 
##########################################################
resource "aws_subnet" "us-east-1a-public" {
    vpc_id = "${aws_vpc.main.id}"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    cidr_block = "10.0.0.0/23"

    tags {
        Name = "AZ A Public subnet"
        AZ = "A"
        Ring = "Public"
    }
}

# Route tables
##########################################################
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.main.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }

    tags {
        Name = "Public"
    }
}

##########################################################

# Route table associations
##########################################################

#Public
resource "aws_route_table_association" "us-east-1a-public" {
    subnet_id = "${aws_subnet.us-east-1a-public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

##########################################################