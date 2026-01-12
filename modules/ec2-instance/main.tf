data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "main" {
  count = var.instance_count

  ami                    = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  user_data              = var.user_data
  user_data_replace_on_change = var.user_data_replace_on_change

  associate_public_ip_address = var.associate_public_ip

  tags = merge(var.tags, {
    Name = "${var.environment}-${var.name_prefix}-${count.index + 1}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

