# Terraform deployment

This module provisions the AWS foundation for the project:

- A dedicated VPC with two public subnets in separate Availability Zones
- An internet-facing Application Load Balancer
- An Amazon ECR repository with image scanning and lifecycle cleanup
- An Amazon ECS Fargate cluster, task definition, and service
- Security groups that expose the container only through the load balancer
- A CloudWatch Logs group with seven-day retention
- An ECS task execution role for ECR image pulls and CloudWatch logging

No NAT gateway is created. The Fargate task receives a public IP for outbound access, while inbound application traffic is restricted to the load balancer security group.

## Two-pass deployment

The default value of `deploy_application` is `false` so Terraform can create ECR before an image exists.

1. Initialize Terraform and apply the foundation.
2. Build, tag, and push the Docker image to the ECR URL from `terraform output`.
3. Set `deploy_application = true` in `terraform.tfvars`.
4. Apply again to create the task definition and ECS service.
5. Open the `application_url` output after the service reaches a steady state.

Do not commit `terraform.tfstate`, `.terraform/`, or a real `terraform.tfvars` file. Commit `.terraform.lock.hcl` after `terraform init`.

## Cleanup

From this directory, run:

```bash
terraform destroy
```

Review the destruction plan before confirming it. The ECR repository is configured with `force_delete = true`, so destroying the project also removes its stored images.
