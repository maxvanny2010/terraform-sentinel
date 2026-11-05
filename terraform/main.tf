resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 8
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-web"
  }
}