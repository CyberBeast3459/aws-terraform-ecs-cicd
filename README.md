# AWS Terraform ECS CI/CD

A portfolio project that deploys a containerized Flask status dashboard to Amazon ECS Fargate. Infrastructure is provisioned with Terraform, and GitHub Actions will test, build, scan, and publish the application to Amazon ECR before deploying it to ECS.

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

## CI/CD security gate

The GitHub Actions pipeline now runs in this order:

1. Install dependencies and run the automated test suite.
2. Build the Docker image once with `docker build --pull` and tag it immutably as `cloud-status-dashboard:${{ github.sha }}`.
3. Run the Docker Security Auditor and write the report to `reports/docker-security-audit.json`.
4. Upload the JSON report as an artifact named `docker-security-audit-${{ github.sha }}` so it can be downloaded from the Actions run.
5. Enforce the security gate: exit code `0` passes, exit code `1` (MEDIUM) logs a warning and continues, and exit codes `2` or `3` (HIGH or CRITICAL) fail the workflow and block the image from being pushed. Exit code `4` or any unexpected code is treated as an operational error.
6. On pushes to `main`, only after the gate passes, authenticate with AWS OIDC, log in to ECR, and push the already-scanned image under both the commit tag and `latest`.

MEDIUM findings generate a warning but do not block deployment. HIGH and CRITICAL findings block deployment until the image is remediated.

## Project stages

- [x] Flask application and automated tests
- [x] Dockerfile using a non-root runtime user
- [x] Terraform infrastructure code
- [x] Amazon ECR repository configuration
- [x] Amazon ECS Fargate service configuration
- [x] CloudWatch logs and load-balancer health-check configuration
- [x] Successful AWS deployment
- [x] GitHub Actions CI/CD with AWS OIDC authentication
- [x] Architecture diagram, screenshots, and deployment documentation

## Cost note

The Terraform configuration intentionally uses public subnets without a NAT gateway. The Application Load Balancer, Fargate task, public IPv4 addresses, ECR storage, and CloudWatch usage can still incur charges while deployed. Run `terraform destroy` after capturing the project evidence if the environment is no longer needed.
