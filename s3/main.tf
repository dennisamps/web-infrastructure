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

# resource "aws_s3_bucket_policy" "backend" {
#   bucket = aws_s3_bucket.backend.id


#   policy = jsonencode({
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": "s3:ListBucket",
#       "Resource": "arn:aws:s3:::terraform-backend-dennis-nginx"
#     },
#     {
#       "Effect": "Allow",
#       "Principal": "*",
#       "Action": ["s3:GetObject", "s3:PutObject"],
#       "Resource": "arn:aws:s3:::terraform-backend-dennis-nginx/state.tf"
#     }
#   ]
# })
# }