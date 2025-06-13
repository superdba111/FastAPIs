# -----------------------------
# terraform/terraform.tfvars
# -----------------------------
subnet_ids = ["subnet-0739b0384785781cc", "subnet-01b3659c181e7a89b"]
security_group_ids = ["sg-05ee2e7c0a27df585"]
bucket_name = "nws-vue-frontend-bucket"

# -----------------------------
# .gitlab-ci.yml
# -----------------------------
stages:
  - build
  - deploy

build-fastapi:
  stage: build
  script:
    - cd backend && python bootstrap.py
  artifacts:
    paths:
      - backend/fastapi.zip

deploy-terraform:
  stage: deploy
  script:
    - cd terraform
    - terraform init
    - terraform apply -auto-approve