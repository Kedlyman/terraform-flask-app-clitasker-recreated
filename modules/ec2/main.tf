resource "aws_key_pair" "default" {
  key_name   = var.key_name
  public_key = var.public_key_material
}

resource "aws_instance" "app" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.default.key_name
  iam_instance_profile        = var.instance_profile_name

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = var.instance_name
  }
}
