resource "aws_iam_role" "ec2InstanceRole" {
  name               = "EC2_Instance_Role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com",
          "iam.amazonaws.com",
          "ssm.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2Instance_attach_ssm" {
  role       = aws_iam_role.ec2InstanceRole.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2InstanceProfile" {
  name = "EC2_Instance_Profile"
  role = aws_iam_role.ec2InstanceRole.name
}

