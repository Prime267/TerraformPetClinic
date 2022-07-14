
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



resource "aws_iam_instance_profile" "my_profile" {


  name = "terra_instance_profile"
  role = aws_iam_role.ssm-role.name
}

resource "aws_iam_role_policy_attachment" "test_attach" {

  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  ])

  role       = aws_iam_role.ssm-role.name
  policy_arn = each.value

}
