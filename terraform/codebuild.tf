
resource "aws_iam_role" "codebuild_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  path               = "/"
}


resource "aws_iam_policy" "codebuild_policy" {
  description = "Policy to allow codebuild to execute build spec"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents",
        "ecr:GetAuthorizationToken"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": [
        "s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.prod_artifact_bucket.arn}/*"
    },
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.image_db.arn}"
    },
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.image_redis.arn}"
    },
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.image_worker.arn}"
    },
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.image_result.arn}"
    },
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
        "ecr:PutImage"
      ],
      "Effect": "Allow",
      "Resource": "${aws_ecr_repository.image_vote.arn}"
    },
    {
      "Action" : [
        "codecommit:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_codecommit_repository.prod_codecommit.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "codebuild-attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}


resource "aws_codebuild_project" "prod_codebuild" {

  depends_on = [
    aws_codecommit_repository.prod_codecommit,
    aws_ecr_repository.image_db,
    aws_ecr_repository.image_redis,
    aws_ecr_repository.image_result,
    aws_ecr_repository.image_vote,
    aws_ecr_repository.image_worker
  ]

  name          = var.infra_name
  service_role  = aws_iam_role.codebuild_role.arn
  description   = "The CodeBuild project for ${var.repo_name}"
  build_timeout = var.code_build_timeout

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "ECR_DB_URI"
      value = aws_ecr_repository.image_db.repository_url
    }
    environment_variable {
      name  = "ECR_REDIS_URI"
      value = aws_ecr_repository.image_redis.repository_url
    }
    environment_variable {
      name  = "ECR_RESULT_URI"
      value = aws_ecr_repository.image_result.repository_url
    }
    environment_variable {
      name  = "ECR_WORKER_URI"
      value = aws_ecr_repository.image_worker.repository_url
    }
    environment_variable {
      name  = "ECR_VOTE_URI"
      value = aws_ecr_repository.image_vote.repository_url
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.aws_region
    }
    environment_variable {
      name  = "CODECOMMIT_REPO_NAME"
      value = var.repo_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<BUILDSPEC
version: 0.2
phases:
  install:
    runtime-versions:
      docker: 19
    commands:
      - git config --global credential.helper '!aws codecommit credential-helper $@'
      - git config --global credential.UseHttpPath true
  pre_build:
    commands:
      - IMAGE_TAG=$CODEBUILD_BUILD_NUMBER
      - echo "Install kustomize..."
      - curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash
      - mv ./kustomize /usr/bin/kustomize && chmod +x /usr/bin/kustomize
      - kustomize version
      - echo "Install yq..."      
      - wget https://github.com/mikefarah/yq/releases/download/v4.12.0/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
      - yq --version
      - echo Logging in to Amazon ECR...
      - $(aws ecr get-login --region $AWS_DEFAULT_REGION --no-include-email)
      - git config --global user.email "codeforcookie@gmail.com"
      - git config --global user.name "Prasanha Kumar"
      - echo "Pre build complete..."
  build:
    commands:
      - print '------------------------------------'
      - echo Build started on `date`
      - echo Building the db image...
      - cd application/db
      - docker build -t $ECR_DB_URI:latest .
      - docker tag $ECR_DB_URI:latest $ECR_DB_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Building the redis image...
      - cd ../..
      - cd application/redis
      - docker build -t $ECR_REDIS_URI:latest .
      - docker tag $ECR_REDIS_URI:latest $ECR_REDIS_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Building the result image...
      - cd ../..
      - cd application/result
      - docker build -t $ECR_RESULT_URI:latest .
      - docker tag $ECR_RESULT_URI:latest $ECR_RESULT_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Building the vote image...
      - cd ../..
      - cd application/vote
      - docker build -t $ECR_VOTE_URI:latest .
      - docker tag $ECR_VOTE_URI:latest $ECR_VOTE_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Building the worker image...
      - cd ../..
      - cd application/worker
      - docker build -t $ECR_WORKER_URI:latest .
      - docker tag $ECR_WORKER_URI:latest $ECR_WORKER_URI:$IMAGE_TAG
      - print '------------------------------------'
      - docker image ls
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker db image...
      - docker push $ECR_DB_URI:latest
      - docker push $ECR_DB_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Pushing the Docker redis image...
      - docker push $ECR_REDIS_URI:latest
      - docker push $ECR_REDIS_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Pushing the Docker vote image...
      - docker push $ECR_VOTE_URI:latest
      - docker push $ECR_VOTE_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Pushing the Docker result image...
      - docker push $ECR_RESULT_URI:latest
      - docker push $ECR_RESULT_URI:$IMAGE_TAG
      - print '------------------------------------'
      - echo Pushing the Docker worker image...
      - docker push $ECR_WORKER_URI:latest
      - docker push $ECR_WORKER_URI:$IMAGE_TAG
      - print '------------------------------------'
      - cd ../..
      - echo Update k8s manifest files...
      - mkdir -p /tmp/project-cicd
      - cd /tmp/project-cicd
      - echo "Clone the repository..."
      - git clone "https://git-codecommit.$AWS_DEFAULT_REGION.amazonaws.com/v1/repos/$CODECOMMIT_REPO_NAME" /tmp/project-cicd 
      - yq e '.images[0].newTag = "$IMAGE_TAG"' -i kustomizations/overlays/prod/kustomization.yaml
      - kustomize build kustomizations/overlays/prod > k8s-manifest/deployment.yaml
      - cat k8s-manifest/deployment.yaml
      - git commit --allow-empty -am "CodeBuild:$CODEBUILD_BUILD_NUMBER Automatic commit"
      - git push origin master
      - echo "Complete..."
BUILDSPEC
  }

  tags = {
    Name        = "${var.infra_name}-codebuild"
    Environment = var.infra_env
  }
}