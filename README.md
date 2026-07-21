# AWS Terraform ECS CI/CD

A portfolio project that deploys a containerized Flask status dashboard to Amazon ECS Fargate. Infrastructure will be provisioned with Terraform, and GitHub Actions will test, build, and publish the application to Amazon ECR before deploying it to ECS.

## Planned architecture

`GitHub → GitHub Actions → Amazon ECR → Amazon ECS Fargate → CloudWatch Logs`

## Current stage

Stage 1 is complete: the Flask application, health endpoint, automated tests, and production Docker image are scaffolded.

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
- [ ] Terraform infrastructure
- [ ] Amazon ECR repository
- [ ] Amazon ECS Fargate service
- [ ] CloudWatch logs and health checks
- [ ] GitHub Actions CI/CD with AWS OIDC authentication
- [ ] Architecture diagram, screenshots, and deployment documentation
