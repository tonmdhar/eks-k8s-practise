# EKS + Kubernetes Practice Project

A production-ready deployment practice project: Java REST API → Docker → AWS EKS (Kubernetes) with Terraform IaC, monitoring, and CI/CD.

## Architecture

```
AWS VPC (10.1.0.0/16)
├── Public Subnets (NAT Gateway — outbound only)
└── Private Subnets
    └── EKS Cluster: k8s-practice
        ├── java-app         (Spring Boot API, 3 replicas)
        ├── java-app-service (ClusterIP, port 80 → 8080)
        ├── data-backup      (CronJob, daily 2AM UTC)
        ├── network-policy   (ingress restricted to port 8080)
        └── prometheus       (metrics collection)
```

## Prerequisites

- Java 17 + Maven
- Docker (Colima on Mac: `brew install colima docker docker-buildx`)
- AWS CLI configured
- Terraform >= 1.5.0
- kubectl (`brew install kubectl`)

## Quick Start

```bash
# 1. Deploy infrastructure (VPC, EKS, ECR, builds & pushes Docker image)
cd terraform
terraform init -upgrade
terraform apply

# 2. Configure kubectl
aws eks update-kubeconfig --name k8s-practice --region us-east-1

# 3. Deploy application
kubectl apply -f kubernetes/base/

# 4. Verify
kubectl exec <pod-name> -- curl -s java-app-service/health
kubectl exec <pod-name> -- curl -s java-app-service/api/data
```

## Rebuild & Redeploy

```bash
# After code changes:
cd terraform && terraform apply
kubectl rollout restart deployment java-app
```

## Project Structure

```
├── app/                          Java Spring Boot application
│   ├── pom.xml                   Maven dependencies
│   └── src/.../App.java          REST API + scheduled jobs
├── docker/
│   └── Dockerfile                Multi-stage build (Maven → JRE)
├── kubernetes/base/
│   ├── deployment.yaml           3 replicas, probes, resource limits
│   ├── service.yaml              ClusterIP service
│   ├── cronjob.yaml              Daily backup job
│   ├── network-policy.yaml       Ingress rules
│   └── secret.yaml               DB credentials
├── terraform/
│   ├── eks.tf                    EKS cluster + node group
│   ├── vpc.tf                    VPC, subnets, NAT Gateway
│   ├── iam.tf                    IAM roles (cluster + nodes)
│   ├── ecr.tf                    ECR repo + Docker push automation
│   ├── provider.tf               AWS provider config
│   └── push.sh                   Build & push script
├── monitoring/prometheus/
│   └── prometheus.yaml           Scrape config
├── ci-cd/
│   └── ci-cd.yml                 GitHub Actions workflow
└── SESSION_NOTES.md              Detailed session history & learnings
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Health status + timestamp |
| `/api/data` | GET | Request count + message |
| `/actuator/prometheus` | GET | Prometheus metrics |

## Cleanup

```bash
kubectl delete -f kubernetes/base/
cd terraform && terraform destroy
colima stop
```
