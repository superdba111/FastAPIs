# -----------------------------
# terraform/terraform.tfvars
# -----------------------------
subnet_ids = ["subnet-xxxxxx", "subnet-yyyyyy"]
security_group_ids = ["sg-xxxxxx"]
bucket_name = "my-vue-frontend-bucket"

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