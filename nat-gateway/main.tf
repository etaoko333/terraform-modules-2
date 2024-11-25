# allocate elastic ip.
resource "aws_eip" "eip1" {
 domain = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-eip1"
  }
}

 # allocate elastic ip.
resource "aws_eip" "eip2" {
  domain = "vpc"
 
 tags = {
    Name = "${var.project_name}-${var.environment}-eip2"
  }

}
# Create NAT Gateway in Public Subnet AZ1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = var.public_subnet_az1_id

  tags = {
    Name = "${var.project_name}-${var.environment}-ng-az1"
  }

  # Ensure proper ordering
  depends_on = [var.internet_gateway]
}

# Create NAT Gateway in Public Subnet AZ2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = var.public_subnet_az2_id

  tags = {
    Name = "${var.project_name}-${var.environment}-ng-az2"
  }

  # Ensure proper ordering
  depends_on = [var.internet_gateway]
}

# Create Private Route Table for AZ1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
    
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az1"
  }
}

# Associate Private App Subnet in AZ1 with Route Table AZ1
resource "aws_route_table_association" "private_app_subnet_az1_rt_az1_association" {
  subnet_id      = var.private_app_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

# Associate Private Data Subnet in AZ1 with Route Table AZ1
resource "aws_route_table_association" "private_data_subnet_az1_rt_az1_association" {
  subnet_id      = var.private_data_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

# Create Private Route Table for AZ2
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az2"
  }
}

# Associate Private App Subnet in AZ2 with Route Table AZ2
resource "aws_route_table_association" "private_app_subnet_az2_rt_az2_association" {
  subnet_id      = var.private_app_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}

# Associate Private Data Subnet in AZ2 with Route Table AZ2
resource "aws_route_table_association" "private_data_subnet_az2_rt_az2_association" {
  subnet_id      = var.private_data_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}
