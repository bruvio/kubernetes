
resource "aws_key_pair" "deployer" {
  key_name   = var.key-name
  public_key = file("${path.module}/${var.public_key}")
}