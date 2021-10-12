resource "aws_s3_bucket" "backend" {
  bucket = var.bucket-name

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  } 

  tags = {
    Name        = var.bucket-name
  }
}

