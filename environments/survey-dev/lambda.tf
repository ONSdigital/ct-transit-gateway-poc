resource "aws_iam_role" "dev_lambda_role" {
  name = "role_for_dev_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dev_lambda_role_policy" {
  name = "dev_lambda_role_policy"
  role = "${aws_iam_role.dev_lambda_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "lambda:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_lambda_layer_version" "dev_lambda_layer" {
    filename = "files/requests-layer.zip"
    layer_name = "python-requests-layer"

    compatible_runtimes = ["python3.7"]
}

resource "aws_lambda_function" "dev_lambda" {
    filename = "files/dev_lambda.zip"
    function_name = "results_dev_lambda"
    handler = "devlambda.handler"
    layers = ["${aws_lambda_layer_version.dev_lambda_layer.layer_arn}"]
    
    role = "${aws_iam_role.dev_lambda_role.arn}"
    runtime = "python3.7"
}
