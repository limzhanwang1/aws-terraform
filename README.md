<h1>🚀 Cloud & Web Workspace (project)</h1>
A centralized workspace hosting personal web infrastructure, cloud automation with Terraform, and web deployment projects.

```text
project/
└── aws-terraform/            # AWS + Cloudflare Serverless Infrastructure (IaC)
    ├── modules/
    │   ├── s3_website/       # S3 static hosting, OAC bucket policy & site asset uploads
    │   └── cloudfront/       # CloudFront distribution CDN & CloudFront Functions
    ├── main.tf               # Root Terraform configuration
    ├── variables.tf          # Variable definitions
    └── outputs.tf            # CDN endpoint outputs
```


🛠️ Projects Overview
=================
aws-terraform — Serverless Web Infrastructure
Managed using Terraform to provision a zero-cost, high-security static hosting architecture on AWS & Cloudflare.

S3 Static Bucket: Private storage bucket with Origin Access Control (OAC).

CloudFront CDN: Edge routing, SSL distribution, and host-header restriction functions.
Cloudflare Integration: DNS proxying, CNAME management, and edge performance optimization.
Automated CI/CD: Passwordless deployment via GitHub Actions OIDC.

⚙️ Quickstart & Local Setup
------------
Prerequisites
Git: >= 2.30
Terraform: >= 1.5.0


🔒 Security Practices
------------
OIDC Authentication: CI/CD deployments utilize temporary AWS STS credentials generated dynamically via GitHub Actions OIDC—eliminating long-lived API keys.
Private S3 Access: Public direct access to S3 is blocked; content is strictly served via CloudFront OAC.
Direct CloudFront Bypass Prevention: A lightweight CloudFront Function blocks direct traffic to default *.cloudfront.net domains, forcing traffic through designated custom domains.

