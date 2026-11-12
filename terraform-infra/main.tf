terraform {
  required_version = ">= 1.11.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
	bucket ="homechoice" 
	key = "log-analyzer/prod/terraform.tfstate"
	region = "us-east-1"
	encrypt = true
	use_lockfile = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "log_analyzer" {
  name                 = "log-analyzer-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "log_analyzer" {
  name = "log-analyzer-cluster"
}

resource "aws_ecs_service" "log-analyzer-service" {
  name = "log-analyzer-service"
  cluster = aws_ecs_cluster.log_analyzer.id
  task_definition = aws_ecs_task_definition.log_analyzer_task.arn
  desired_count = 1
  launch_type = "FARGATE"

  network_configuration {
	subnets = ["subnet-default-us-east-1-c"  ]
	security_groups = [ "sg-default-us-east-1" ]
	assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "log_analyzer_task" {
  family                   = "log-analyzer-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  # Dynamically interpolate the account ID variable into the IAM role ARN
  execution_role_arn = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "api"
      image     = "${aws_ecr_repository.log_analyzer.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
    }
  ])
}