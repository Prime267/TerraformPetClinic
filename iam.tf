resource "aws_iam_instance_profile" "my_profile" {
  name = "test_profile"
  role = aws_iam_role.ssm-role.name
}

resource "aws_iam_role" "ssm-role" {
  name = "ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.ssm-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


# resource "aws_ssm_activation" "foo" {
#   name               = "ssm_activation"
#   iam_role           = aws_iam_role.ssm-role.id
#   depends_on         = [aws_iam_role_policy_attachment.test_attach]
# }
