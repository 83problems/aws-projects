resource "aws_route53domains_registered_domain" "route_53_reg_domain" {
  domain_name        = var.domainname
  admin_privacy      = true
  registrant_privacy = true
  tech_privacy       = true
  transfer_lock      = true

  tags = {
    Terraform = true
    Name      = "aws_route53domains_registered"
  }
}

resource "aws_kms_key" "domaindnssec" {
  customer_master_key_spec = "ECC_NIST_P256"
  deletion_window_in_days  = 7
  key_usage                = "SIGN_VERIFY"
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:DescribeKey",
          "kms:GetPublicKey",
          "kms:Sign",
        ],
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service",
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${data.aws_caller_identity.current.account_id}"
          }
          ArnLike = {
            "aws:SourceArn" = "arn:aws:route53:::hostedzone/*"
          }
        }
      },
      {
        Action = "kms:CreateGrant",
        Effect = "Allow"
        Principal = {
          Service = "dnssec-route53.amazonaws.com"
        }
        Sid      = "Allow Route 53 DNSSEC Service to CreateGrant",
        Resource = "*"
        Condition = {
          Bool = {
            "kms:GrantIsForAWSResource" = "true"
          }
        }
      },
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "Enable IAM User Permissions"
      },
    ]
    Version = "2012-10-17"
  })
}

resource "aws_route53_key_signing_key" "secondratedevshop_ksk" {
  hosted_zone_id             = data.aws_route53_zone.primary.zone_id
  key_management_service_arn = aws_kms_key.domaindnssec.arn
  name                       = "secondratedevshop.com"
}

resource "aws_route53_hosted_zone_dnssec" "secondratedevshop_dnssec" {
  depends_on = [
    aws_route53_key_signing_key.secondratedevshop_ksk
  ]
  hosted_zone_id = aws_route53_key_signing_key.secondratedevshop_ksk.hosted_zone_id
}
