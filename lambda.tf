resource "aws_iam_role" "lambda_role" {
  name_prefix = "lambda_role"
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

data "archive_file" "test_lambda" {
  type        = "zip"
  source_file = "src/lambda.js"
  output_path = "${path.root}/lambda.zip"
}

resource "aws_lambda_function" "test" {
  filename = "${data.archive_file.test_lambda.output_path}"
  function_name = "test-lambda"
  handler = "lambda.handler"
  source_code_hash = "${data.archive_file.test_lambda.output_base64sha256}"
  runtime = "nodejs6.10"
  role = "${aws_iam_role.lambda_role.arn}"
  publish = "${local.prod}"

  environment {
    variables = {
      APP_ENV = "${var.stage}"
    }
  }
}

resource "aws_lambda_alias" "test_development" {
  name = "development"
  description = "Version: development"
  function_name = "${aws_lambda_function.test.arn}"
  function_version = "$LATEST"
}

resource "aws_lambda_alias" "test_production" {
  depends_on = [
    "aws_lambda_function.test"
  ]
  name = "production"
  description = "Version: production"
  function_name = "${aws_lambda_function.test.arn}"
  function_version = "${aws_lambda_function.test.version}"
}
