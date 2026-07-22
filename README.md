# AWS Terraform ECS CI/CD

A portfolio project that deploys a containerized Flask status dashboard to Amazon ECS Fargate. Infrastructure is provisioned with Terraform, and GitHub Actions will test, build, and publish the application to Amazon ECR before deploying it to ECS.

## Planned architecture

`GitHub → GitHub Actions → Amazon ECR → Amazon ECS Fargate → Application Load Balancer`

Container logs are sent to Amazon CloudWatch Logs.

## Current stage

Stage 1 is complete: the Flask application passes its automated tests and runs locally as a non-root Docker container. Stage 2 Terraform infrastructure is scaffolded and awaiting deployment to AWS.

## Run locally

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
pytest
flask --app app.app run --port 8080
```

Open `http://localhost:8080` and verify `http://localhost:8080/health`.

## Run with Docker

```bash
docker build -t cloud-status-dashboard .
docker run --rm -p 8080:8080 cloud-status-dashboard
```

## Project stages

- [x] Flask application and automated tests
- [x] Dockerfile using a non-root runtime user
- [x] Terraform infrastructure code
- [x] Amazon ECR repository configuration
- [x] Amazon ECS Fargate service configuration
- [x] CloudWatch logs and load-balancer health-check configuration
- [ ] Successful AWS deployment
- [ ] GitHub Actions CI/CD with AWS OIDC authentication
- [ ] Architecture diagram, screenshots, and deployment documentation

## Cost note

The Terraform configuration intentionally uses public subnets without a NAT gateway. The Application Load Balancer, Fargate task, public IPv4 addresses, ECR storage, and CloudWatch usage can still incur charges while deployed. Run `terraform destroy` after capturing the project evidence if the environment is no longer needed.
