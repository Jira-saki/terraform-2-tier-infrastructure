# AWS 2-Tier Infrastructure with Terraform

A secure, production-ready two-tier web application infrastructure deployed on AWS using Infrastructure as Code (Terraform).

![Architecture Diagram](secure-vpc.png)

## 🏗️ Architecture Overview

This project implements a classic 2-tier architecture with clear separation between web and database layers:

- **Web Tier**: Public-facing EC2 instance running Nginx in a public subnet
- **Database Tier**: RDS PostgreSQL database isolated in a private subnet
- **Network**: VPC with proper segmentation across multiple Availability Zones

## 📋 Infrastructure Components

| Component | Specification | Purpose |
|-----------|--------------|---------|
| **VPC** | 10.0.0.0/16 | Isolated network environment |
| **Public Subnet** | 10.0.1.0/24 (ap-northeast-3a) | Hosts web server with internet access |
| **Private Subnet** | 10.0.2.0/24 (ap-northeast-3b) | Hosts database with no internet access |
| **Internet Gateway** | - | Routes public traffic to/from VPC |
| **EC2 Instance** | t2.micro (Ubuntu 22.04 + Nginx) | Web server |
| **RDS PostgreSQL** | db.t3.micro, PostgreSQL 16.11, 10GB storage | Database server |

## 🔒 Security Features

### Network Isolation
- ✅ Database in **private subnet** with no direct internet access
- ✅ Only web server has public IP address
- ✅ Multi-AZ deployment for fault tolerance

### Security Groups (Least Privilege)
- **web-sg**: Allows HTTP (80), HTTPS (443), SSH (22) from internet
- **db-sg**: Allows PostgreSQL (5432) **only from web-sg**, not from internet
- Database cannot be accessed directly from outside the VPC

### Access Control
- ✅ Database credentials stored as sensitive Terraform variables
- ✅ RDS endpoint is private (VPC-only access)
- ✅ Web server acts as the only entry point to database

### Infrastructure as Code
- ✅ Terraform ensures consistent, repeatable deployments
- ✅ Version-controlled configuration
- ✅ Easy to audit and review security settings

## 🚀 Deployment

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.0
- AWS account with necessary permissions

### Steps

1. **Clone the repository**
```bash
git clone <repository-url>
cd terraform-2-tier-infrastructure
```

2. **Initialize Terraform**
```bash
terraform init
```

3. **Create terraform.tfvars**
```hcl
aws_region           = "ap-northeast-3"
project_name         = "two-tier-app"
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidr   = "10.0.1.0/24"
private_subnet_cidr  = "10.0.2.0/24"
db_password          = "YourSecurePassword123!"
```

4. **Plan and Apply**
```bash
terraform plan
terraform apply
```

5. **Get Outputs**
```bash
terraform output web_public_ip
terraform output rds_endpoint
```

6. **Test Deployment**
```bash
# Visit web server
curl http://$(terraform output -raw web_public_ip)
```

## 📊 Project Completion Checklist

### ✅ 1. Networking & Isolation (VPC Layer)
- [x] VPC Created with dedicated CIDR block (10.0.0.0/16)
- [x] Subnet Segmentation across different Availability Zones
- [x] Internet Gateway and public Route Table configured
- [x] Private subnet isolated from Internet Gateway

### ✅ 2. Security & Access Control (Least Privilege)
- [x] Shared Responsibility Model applied
- [x] Web Security Group with restricted inbound ports (80, 443, 22)
- [x] Database Security Group restricted to Web SG only (port 5432)
- [x] Principle of Least Privilege implemented

### ✅ 3. Key Resources Deployed
- [x] Web Server (EC2 t2.micro) in public subnet
- [x] Database (RDS PostgreSQL 16.11) in private subnet
- [x] Infrastructure defined as Terraform code

## 💰 Cost Estimation

Approximate monthly costs (ap-northeast-3 region):

| Resource | Instance Type | Monthly Cost |
|----------|--------------|--------------|
| EC2 Web Server | t2.micro | ~$8.50 |
| RDS PostgreSQL | db.t3.micro | ~$12.50 |
| Data Transfer | Minimal | ~$1.00 |
| **Total** | | **~$22/month** |

## ⚠️ Known Security Gaps

| Issue | Risk | Recommendation |
|-------|------|----------------|
| SSH open to 0.0.0.0/0 | High | Restrict to specific IP or use AWS Systems Manager |
| No NAT Gateway | Medium | Add NAT Gateway for private subnet updates |
| Single AZ web server | Medium | Use Auto Scaling Group across multiple AZs |
| No encryption specified | Medium | Enable RDS encryption at rest and SSL/TLS |
| No backup strategy | High | Enable automated RDS backups |

## 🔄 Next Steps: DevSecOps Pipeline

### Phase 1: CI/CD Pipeline
- [ ] Integrate GitHub Actions for automated deployment
- [ ] Add Terraform plan validation on pull requests
- [ ] Implement automated testing

### Phase 2: Security Scanning (SAST)
- [ ] Add `tfsec` for Terraform security scanning
- [ ] Integrate `checkov` for policy-as-code validation
- [ ] Implement pre-commit hooks

### Phase 3: Monitoring & Observability
- [ ] Add CloudWatch alarms
- [ ] Implement logging with CloudWatch Logs
- [ ] Set up AWS Config for compliance monitoring

## 📁 Project Structure

```
.
├── main.tf              # Core infrastructure resources
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── provider.tf          # AWS provider configuration
├── terraform.tfvars     # Variable values (gitignored)
├── secure-vpc.png       # Architecture diagram
└── README.md           # This file
```

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Warning**: This will permanently delete all resources including the database.

## 📝 Lessons Learned

### Deployment Challenges
1. **PostgreSQL Version Compatibility**: Initial version 16.1 not available in ap-northeast-3 region. Resolved by using 16.11.
2. **Reserved Username**: "admin" is reserved in PostgreSQL. Changed to "dbadmin".
3. **Port Configuration**: MySQL (3306) vs PostgreSQL (5432) - security group must match database engine.

### Best Practices Applied
- Used data sources for AMI lookup (always gets latest Ubuntu)
- Separated subnets across availability zones
- Implemented security group referencing (not CIDR blocks) for database access
- Used sensitive variables for credentials

## 🔗 Database Connection

From the web server, connect to PostgreSQL:

```bash
# SSH to web server
ssh ubuntu@<web_public_ip>

# Install PostgreSQL client
sudo apt-get update
sudo apt-get install -y postgresql-client

# Connect to database
psql -h <rds_endpoint> -U dbadmin -d mydb
```

## 📚 References

- [AWS VPC Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-best-practices.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [RDS PostgreSQL Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html)

## 📄 License

This project is for educational and portfolio purposes.

## 👤 Author

Created as part of a DevSecOps learning journey.

---

**Project Status**: ✅ Core Infrastructure Complete | 🚧 CI/CD Pipeline In Progress