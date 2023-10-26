resource "aws_s3_bucket" "bucket" {
  bucket = local.bucket_name

  force_destroy = true

  tags = local.tags
}

resource "aws_s3_access_point" "ap" {
  bucket = aws_s3_bucket.bucket.id
  name   = local.bucket_name

  public_access_block_configuration {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }

  vpc_configuration {
    vpc_id = data.aws_vpc.selected.id # Attach the S3 Access Point to the VPC
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "s3_object" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "index.html"
  content = data.template_file.webpage.rendered
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.policy_s3.json
}

data "aws_iam_policy_document" "policy_s3" { 
  statement {
    sid = "allowVPCEndpoint"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
      "${aws_s3_bucket.bucket.arn}"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceVpce" # Only allow s3 access through the VPC Endpoint

      values = [data.aws_vpc_endpoint.s3.id]
    }
  }

  statement {
    sid = "enforceHTTPS"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    effect = "Deny"

    actions = [
      "s3:*"
    ]

    resources = [
      "${aws_s3_bucket.bucket.arn}/*",
      "${aws_s3_bucket.bucket.arn}"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"

      values = [false]
    }
  }
}
