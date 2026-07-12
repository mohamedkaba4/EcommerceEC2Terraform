# IAM Policy for SSM parameter access
resource "aws_iam_policy" "neon_ssm_policy" {
  name        = "${var.project_name}-${var.environment}-ssm-read"
  description = "Allows EC2 instances to read the Neon DB connection string from Parameter Store"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ssm:GetParameter"
        Resource = "arn:aws:ssm:*:*:parameter${var.ssm_parameter_name}"
      }
    ]
  })
}

# IAM Role and Trust Policy allowing EC2 to assume it
resource "aws_iam_role" "neon_ssm_role" {
  name = "${var.project_name}-${var.environment}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "neon_ssm_attach" {
  role       = aws_iam_role.neon_ssm_role.name
  policy_arn = aws_iam_policy.neon_ssm_policy.arn
}

# Instance Profile container required by EC2 platforms
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "nextjs-ec2-profile-${var.environment}"
  role = aws_iam_role.neon_ssm_role.name 
}
