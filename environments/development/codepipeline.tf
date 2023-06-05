resource "aws_codepipeline" "main" {
  name     = "prospa-app-pipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_repo_owner
        Repo       = var.github_repo_name
        Branch     = "main"
        OAuthToken = var.github_oauth_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName = module.ecs_frontend_app.ecs_cluster_name
        ServiceName = module.ecs_frontend_app.ecs_service_name
        FileName    = "imagedefinitions.json"
        /* ContainerName = "prospa-app-container" */
      }
    }
  }
}

resource "aws_iam_role" "pipeline" {
  name               = "prospa-app-pipeline-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
/* 
resource "aws_iam_role_policy_attachment" "pipeline" {
  role       = aws_iam_role.pipeline.name
  policy_arn = aws_iam_policy.pipeline
} */

resource "aws_iam_policy" "pipeline" {
  name        = "prospa-app-pipeline-policy"
  description = "IAM policy for the pipeline"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:DescribeServices",
        "ecs:UpdateService",
        "ecs:DescribeTaskDefinition",
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:PutImage",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:ecr:us-west-2:123456789012:repository/prospa-app-repo",
        "arn:aws:s3:::prospa-app-bucket/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline_artifacts.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline_artifacts.arn}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "pipeline" {
  name       = "prospa-app-pipeline-attachment"
  roles      = [aws_iam_role.pipeline.name]
  policy_arn = aws_iam_policy.pipeline.arn
}

resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "prospa-app-pipeline-artifacts"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "prospa-app Pipeline Artifacts"
    Environment = "Production"
  }
}

resource "aws_codebuild_project" "build" {
  name          = "prospa-app-build"
  description   = "CodeBuild project for building the application"
  build_timeout = 60

  source {
    type                = "GITHUB"
    location            = "https://github.com/${var.github_repo_owner}/${var.github_repo_name}"
    git_clone_depth     = 1
    buildspec           = "frontend/buildspec.yml"
    report_build_status = true
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  service_role = aws_iam_role.codebuild.arn

  tags = {
    Name = "prospa-app-build"
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "prospa-app-codebuild-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "codebuild_policy" {
  name   = "codebuild-start-build-policy"
  policy = <<EOF
{
	"Statement": [
		{
			"Action": [
				"codebuild:StartBuild",
				"codebuild:BatchGetBuilds",
				"codebuild:BatchGetProjects",
				"codebuild:ListBuilds",
				"codebuild:ListProjects"
			],
			"Effect": "Allow",
			"Resource": "*"
		},
		{
			"Action": [
				"s3:GetObject"
			],
			"Effect": "Allow",
			"Resource": [
				"arn:aws:s3:::prospa-app-pipeline-artifacts/*"
			]
		},
		{
			"Action": [
				"ecr:*"
			],
			"Effect": "Allow",
			"Resource": "*"
		},
		{
			"Action": [
				"secretsmanager:GetSecretValue"
			],
			"Effect": "Allow",
			"Resource": "arn:aws:secretsmanager:*:*:secret:your-secret-name*"
		},
		{
			"Action": [
				"kms:Decrypt"
			],
			"Effect": "Allow",
			"Resource": "arn:aws:kms:*:*:key/your-key-id"
		},
		{
			"Action": [
				"cloudwatch:*",
				"logs:CreateLogStream",
				"logs:GetLogRecord",
				"logs:GetLogEvents",
				"logs:DescribeLogGroups"
			],
			"Effect": "Allow",
			"Resource": "*"
		}
	],
	"Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild_attachment" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

resource "aws_iam_role_policy_attachment" "pipeline_codebuild_attachment" {
  role      = aws_iam_role.pipeline.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}