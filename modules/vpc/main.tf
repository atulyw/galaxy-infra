resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  tags                 = merge(var.tags, tomap({ "Name" = format("%s-%s-vpc", var.ns, var.env), "Environment" = var.env }))
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet_cidr[count.index]
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = false
  tags                    = merge(var.tags, tomap({ "Name" = format("%s-%s-private-%s", var.ns, var.env, element(var.availability_zone, count.index)), "Type" = "Private", "Environment" = var.env }))
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr[count.index]
  availability_zone       = element(var.availability_zone, count.index)
  map_public_ip_on_launch = true
  tags                    = merge(var.tags, tomap({ "Name" = format("%s-%s-public-%s", var.ns, var.env, element(var.availability_zone, count.index)), "Type" = "Public", "Environment" = var.env }))
}

# resource "aws_subnet" "db" {
#   count = length(var.db_subnet_cidr)
#   vpc_id = aws_vpc.main.id
#   cidr_block = var.db_subnet_cidr[count.index]
#   map_public_ip_on_launch = false
#   tags = {}
# }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = format("%s-%s-gateway", var.ns, var.env)
  })
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = merge(var.tags, {
    Name = format("%s-%s-public-rt", var.ns, var.env)
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}



resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(var.tags, {
    Name = format("%s-%s-nat", var.ns, var.env)
  })
}

resource "aws_eip" "nat_eip" {
  tags = merge(var.tags, {
    Name = format("%s-%s-eip", var.ns, var.env)
  })
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = merge(var.tags, {
    Name = format("%s-%s-private-rt", var.ns, var.env)
  })
}

resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}


#Create Application Load Balancer with help of module
#Create S3+Cloudfront hosting with Module
#Create RDS Module


#TOPICS:
  # Conditions
  # for_each loop
  # Providers Versions Importance
  # Provisioners
  # How to Register Module
  # How to Use Other's Module
