# DevOps Take-Home Projects Collection

A comprehensive collection of three real-world DevOps take-home assignment projects with complete solutions, architecture diagrams, and implementation details.

## 📋 Project Overview

This collection contains three progressively complex DevOps projects designed for hands-on learning and portfolio building:

| Project | Difficulty | Time | Key Technologies |
|---------|-----------|------|------------------|
| [Project 1: URL Shortener on EKS](#project-1) | Intermediate | 4-6 hours | EKS, Docker, Terraform, CI/CD |
| [Project 2: Multi-Tier API Architecture](#project-2) | Advanced | 8-10 hours | API Gateway, ALB, Route53, VPC, EKS |
| [Project 3: Golden AMI Pipeline](#project-3) | Advanced | 8-12 hours | Packer, EKS, Security Scanning, Python |

---

## Project 1: URL Shortener Microservices Platform

**File:** `01-url-shortener-eks.md`

### What You'll Build
A production-grade URL shortener with microservices architecture deployed on AWS EKS.

### Key Learning Outcomes
- Container orchestration with Kubernetes
- Microservices design patterns
- Infrastructure as Code with Terraform
- CI/CD pipeline implementation
- Observability and monitoring

### Technologies
- AWS EKS, ECR, RDS
- Docker & Kubernetes
- Terraform
- Prometheus & Grafana
- GitHub Actions / GitLab CI

### Architecture Highlights
```
Internet → LoadBalancer → API Service → Redis/PostgreSQL
                       → Analytics Service → Message Queue
```

---

## Project 2: Multi-Tier API Security & CVE Response

**File:** `02-multi-tier-api-architecture.md`

### What You'll Build
Enterprise-grade multi-tier API architecture with centralized and squad-level gateways, demonstrating CVE detection and remediation.

### Key Learning Outcomes
- Complex enterprise networking patterns
- Private vs public API gateway design
- VPC architecture and security groups
- CVE detection and response workflows
- Request tracing through multiple tiers

### Technologies
- AWS API Gateway (REST & Private)
- Application Load Balancers
- Route53 (Public & Private Hosted Zones)
- VPC Endpoints & VPC Links
- EKS with nginx-ingress
- Trivy/Grype security scanning

### Architecture Highlights
```
Public DNS → API GW (Central) → ALB → Private Route53 
→ API GW (Squad) → ALB → EKS Ingress → Pods
```

---

## Project 3: Golden AMI Management Pipeline

**File:** `03-golden-ami-pipeline.md`

### What You'll Build
Automated pipeline for building, scanning, and deploying hardened Golden AMIs to EKS node groups with CVE remediation workflows.

### Key Learning Outcomes
- Immutable infrastructure patterns
- Security hardening automation
- CVE scanning and remediation
- EKS node lifecycle management
- Launch template and rolling updates

### Technologies
- Packer for AMI building
- Trivy/Grype for vulnerability scanning
- Terraform for EKS infrastructure
- Python for automation
- Lambda for AMI updates
- CIS hardening standards

### Architecture Highlights
```
Packer Build → Security Scan → AMI Publish 
→ Launch Template Update → Rolling Node Replacement
```

---

## 🎯 How to Use This Collection

### For Learning
1. **Start with Project 1** if you're new to EKS and microservices
2. **Move to Project 2** to understand complex enterprise architectures
3. **Complete Project 3** to master security and immutable infrastructure

### For Job Applications
Each project is designed to be submitted as a take-home assignment with:
- Complete documentation
- Working code
- Architecture diagrams
- Testing procedures
- Cost analysis

### For Portfolio
Deploy these projects and include:
- Live demo links
- GitHub repositories
- Architecture walkthroughs
- Blog posts about challenges faced

---

## 📚 Common Patterns Across Projects

### Infrastructure as Code
All projects use Terraform with:
- Modular structure
- Remote state management
- Proper tagging and naming
- Cost optimization

### Security Best Practices
- No hardcoded credentials
- IAM roles and policies (least privilege)
- Security groups with minimal access
- Secret management (AWS Secrets Manager)
- Vulnerability scanning

### Observability
- Structured logging
- Metrics collection (Prometheus)
- Distributed tracing
- Dashboards (Grafana)
- Alerting rules

### CI/CD Patterns
- Automated testing
- Docker image building
- Security scanning in pipeline
- Staged deployments
- Rollback capabilities

---

## 💰 Cost Considerations

Each project includes detailed cost analysis, but here are estimates for running all three:

| Resource | Monthly Cost | Notes |
|----------|--------------|-------|
| EKS Control Plane (3 clusters) | $219 | $73 per cluster |
| EC2 Instances (t3.medium x6) | $180 | Destroy when not testing |
| ALB (4 load balancers) | $80 | ~$20 per ALB |
| Route53 Hosted Zones | $3 | $0.50 per zone |
| API Gateway | $5 | Pay per request |
| S3, ECR, CloudWatch | $10 | Minimal usage |
| **Total if running 24/7** | **~$497** | |
| **Practical cost** | **<$50** | Only run during testing |

**💡 Pro Tip:** Destroy resources between testing sessions!

---

## 🛠️ Prerequisites

### Required Tools
```bash
# Install on macOS
brew install terraform packer awscli kubectl helm

# Install Python packages
pip install boto3 ansible

# Install Docker Desktop
# https://www.docker.com/products/docker-desktop
```

### AWS Setup
```bash
# Configure AWS CLI
aws configure

# Set default region
export AWS_REGION=us-east-1
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
```

### Recommended VS Code Extensions
- HashiCorp Terraform
- Docker
- Kubernetes
- YAML
- Markdown Preview Mermaid

---

## 📖 Documentation Structure

Each project document includes:

1. **Project Overview**
   - Business context
   - Learning objectives
   - Time estimates

2. **Architecture**
   - Mermaid diagrams
   - Component descriptions
   - Data flow

3. **Requirements**
   - Functional requirements
   - Technical specifications
   - Acceptance criteria

4. **Implementation Guide**
   - Step-by-step instructions
   - Code examples
   - Configuration files

5. **Solution Files**
   - Complete Terraform code
   - Kubernetes manifests
   - Scripts and automation
   - CI/CD configurations

6. **Testing**
   - Test scenarios
   - Verification steps
   - Troubleshooting guide

7. **Evaluation Rubric**
   - Grading criteria
   - Best practices checklist

---

## 🤝 Contributing

Found an issue or want to improve these projects?
- Submit issues for clarifications
- Propose enhancements
- Share your implementations

---

## 📝 License

These projects are educational resources. Use them for:
- Personal learning
- Job interview take-homes
- Portfolio projects
- Teaching materials

---

## 🎓 Additional Resources

### AWS Documentation
- [EKS Best Practices](https://aws.github.io/aws-eks-best-practices/)
- [Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

### Kubernetes
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Charts](https://helm.sh/docs/)
- [CNCF Landscape](https://landscape.cncf.io/)

### Security
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Trivy Documentation](https://aquasecurity.github.io/trivy/)

---

## 📧 Questions?

Treat these as real take-home assignments:
- Google and documentation are your friends
- Make reasonable assumptions (document them!)
- Ask clarifying questions
- Focus on best practices

**Good luck building your DevOps portfolio! 🚀**

---

**Created:** October 2024  
**Last Updated:** October 2024  
**Version:** 1.0
