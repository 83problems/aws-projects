resource "aws_ssm_activation" "ec2_ssm" {
  name               = "SSM_Activation"
  description        = "Use SSM with EC2 instance"
  iam_role           = aws_iam_role.ec2InstanceRole.id
  registration_limit = "5"
  depends_on         = [aws_iam_role_policy_attachment.ec2Instance_attach_ssm]
}
