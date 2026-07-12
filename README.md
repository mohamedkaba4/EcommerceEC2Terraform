# Core Cloud Infrastructure Architecture

This repository manages the decoupled, highly available AWS production infrastructure for the enterprise e-commerce platform using **Terraform** and Infrastructure as Code (IaC).

---

## Topology

- **Routing Layer:** **AWS Route 53** handles public DNS management for `e-commerce.mavencrest.site`, routing traffic directly to an **Application Load Balancer (ALB)**.
- **Compute Layer:** High availability is enforced via an **Auto Scaling Group (ASG)** deploying EC2 instances across multiple Availability Zones, managed by an automated launch template.
- **Secret Management:** Secure parameters, including the serverless database connection strings, are maintained inside the **AWS Systems Manager (SSM) Parameter Store** using `SecureString` encryption.
- **State Management:** Backend infrastructure state tracking is centralized to ensure team concurrency and locking.

---



## Operational Pipelines



### 1. Execute an Immutable Plan (Dry Run)

To scan the live AWS environment, refresh resources, and generate a locked execution artifact without prompting:
bash
terraform plan -var-file="prod.tfvars" -out=prod.tfplan


### 2. Apply the Immutable Blueprint

To write the pre-reviewed state changes directly to the AWS API with zero prompting overhead:
bash
terraform apply prod.tfplan


### 3. Recover from Record Collisions (Route 53 Import)

If a DNS record exists outside the state file, bind it to your configuration rather than destroying it:
bash
terraform import -var-file="prod.tfvars" aws_route53_record.ecommerce [HostedZoneId]_e-commerce.mavencrest.site_A


### 4. Zero-Downtime Fleet Updates

When updating parameter configurations in SSM, force a rolling instance refresh across the active Auto Scaling Group:
bash
aws autoscaling start-instance-refresh --auto-scaling-group-name "mavencrest-prod-asg" --region us-east-1
