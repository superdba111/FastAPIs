from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import boto3
import json
import os
from botocore.exceptions import ClientError

# 1. Configuration
# Get the Secret Name from environment variable (injected by Terraform)
SECRET_NAME = os.getenv("SECRET_NAME", "nws-dl-sbx-web-secrets")
REGION_NAME = os.getenv("REGION_NAME", "us-east-1")

def get_db_url():
    """
    Fetches credentials from AWS Secrets Manager and returns
    a SQLAlchemy-compatible connection string.
    """
    # OPTIONAL: Allow local override for testing on your laptop
    # If this env var is set, we skip AWS calls (good for local dev)
    if os.getenv("DATABASE_URL_LOCAL"):
        return os.getenv("DATABASE_URL_LOCAL")

    # Initialize Boto3 Client
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=REGION_NAME)

    try:
        get_secret_value_response = client.get_secret_value(SecretId=SECRET_NAME)
    except ClientError as e:
        print(f"Error retrieving secret: {e}")
        raise e

    # Parse Secret
    secret = get_secret_value_response['SecretString']
    creds = json.loads(secret)

    # Construct the PostgreSQL URL
    # Format: postgresql://user:password@host:port/dbname
    return f"postgresql://{creds['username']}:{creds['password']}@{creds['host']}:{creds.get('port', 5432)}/{creds['dbname']}"

# 2. Create Engine using the dynamic URL
SQLALCHEMY_DATABASE_URL = get_db_url()

engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()