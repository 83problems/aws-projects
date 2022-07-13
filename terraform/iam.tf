resource "aws_iam_role" "tfstate_bucket_role" {
  name               = "tfstate_bucket_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {   
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["s3.amazonaws.com"]
      },  
      "Effect": "Allow",
      "Sid": ""
    }   
  ]
}
EOF

  tags = {
    Terraform = true
    Name      = "iam_tfstate_bucket_role"
  }
}

resource "aws_iam_policy" "tf_s3_access" {
  name        = "tf_s3_access_policy"
  description = "Store Terraform state file in S3."

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.tf_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
      "Resource": "${aws_s3_bucket.tf_bucket.arn}/${var.s3_backend_key}"
    }
  ]
}
EOT

  tags = {
    Terraform = true
    Name      = "iam_policy_tfstate"
  }
}

resource "aws_iam_role_policy_attachment" "tfstate_role_policy_attachment" {
  role       = aws_iam_role.tfstate_bucket_role.name
  policy_arn = aws_iam_policy.tf_s3_access.arn
}
