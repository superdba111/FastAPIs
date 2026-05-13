# Serverless FastAPI & Vue.js Admin Portal

A full-stack, serverless web application built with a **Vue 3** frontend and a **Python FastAPI** backend. The entire infrastructure is defined as code using **Terraform** and deployed on AWS for high availability, security, and zero-maintenance scaling.

This project serves as an enterprise-grade Admin Console (e.g., for a Data Lake), demonstrating production patterns such as dynamic credential fetching via AWS Secrets Manager, soft/hard deletion logic, and strict CORS configuration.

---

## Architecture Overview

The application uses a fully decoupled, serverless pipeline on AWS:

| Layer | Service | Role |
|---|---|---|
| Frontend Delivery | S3 + CloudFront | Vue SPA hosted in a private S3 bucket; CloudFront (with OAI) serves it globally over HTTPS |
| API Routing | API Gateway (HTTP API) | Front door for all API traffic — handles CORS and routes requests to Lambda |
| Compute | AWS Lambda + Mangum | FastAPI wrapped with Mangum, deployed inside a VPC, scales automatically |
| Secrets & Config | AWS Secrets Manager | Database credentials fetched at runtime — never hardcoded or stored in environment variables |
| Infrastructure | Terraform | Entire stack modularized into reusable `backend`, `frontend`, and `apigateway` modules |

---

## Tech Stack

**Backend**
- Python 3.11
- FastAPI — RESTful API framework
- SQLAlchemy — ORM with `pg8000` PostgreSQL driver
- Pydantic — Data validation and schemas
- Mangum — ASGI adapter for AWS Lambda

**Frontend**
- Vue.js 3 — Composition / Options API
- Axios — HTTP client
- Custom CSS — no heavy UI framework dependencies

**Infrastructure**
- Terraform
- AWS: CloudFront, S3, API Gateway, Lambda, Secrets Manager, IAM

---

## Repository Structure

```
.
├── backend/
│   └── app/
│       ├── database.py     # AWS Secrets Manager DB connection
│       ├── main.py         # API endpoints + Mangum handler
│       └── ...
├── frontend/
│   └── src/
│       ├── App.vue         # Main Admin Console UI
│       └── ...
└── terraform/
    ├── modules/            # Reusable modules: apigateway, backend, frontend
    ├── main.tf             # Root module
    └── terraform.tfvars    # Environment config: VPC, subnets, buckets
```

---

## Key Features

**Full-Stack User Management** — Complete CRUD operations exposed through the Admin portal UI.

**Soft and Hard Deletes** — Backend supports marking users as `INACTIVE` (soft delete) or permanently removing records from the database (hard delete).

**Secure Credential Management** — The database connection pulls credentials dynamically from AWS Secrets Manager (`nws-dl-sbx-web-secrets`), keeping sensitive data out of environment variables entirely.

**VPC-Integrated Compute** — The Lambda function runs inside designated subnets and security groups to securely reach internal RDS/PostgreSQL instances.

---

## Local Development

### Backend (FastAPI)

```bash
# 1. Navigate to the backend
cd backend/app

# 2. Install dependencies
pip install -r requirements.txt

# 3. Set a local DB URL to bypass Secrets Manager
export DATABASE_URL_LOCAL="postgresql://user:password@localhost:5432/dbname"

# 4. Start the dev server
uvicorn main:app --reload
```

API docs available at: http://localhost:8000/docs

### Frontend (Vue.js)

```bash
# 1. Navigate to the frontend
cd frontend

# 2. Install dependencies
npm install

# 3. Start the dev server
npm run serve
```

App available at: http://localhost:8080

---

## Deployment via Terraform

```bash
# 1. Package the FastAPI application
cd backend && zip -r fastapi.zip app/

# 2. Build the Vue.js application
cd frontend && npm run build

# 3. Deploy infrastructure
cd terraform
terraform init
terraform apply
```

> **Before applying**, ensure `terraform.tfvars` contains your environment-specific values for `subnet_ids`, `security_group_ids`, and `bucket_name`.

---

## License

This project is licensed under the [MIT License](LICENSE).
