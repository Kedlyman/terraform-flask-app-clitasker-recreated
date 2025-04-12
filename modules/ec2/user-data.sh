#!/bin/bash
set -euxo pipefail

# ─────────────────────────────────────────────
# System Preparation
# ─────────────────────────────────────────────
echo "Updating system packages..."
apt-get update -y -qq
apt-get install -y -qq python3 python3-pip python3-venv git unzip jq curl groff less

# ─────────────────────────────────────────────
# Install AWS CLI v2
# ─────────────────────────────────────────────
echo "Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -qq awscliv2.zip
./aws/install --update
rm -rf awscliv2.zip aws

# ─────────────────────────────────────────────
# Set up Python Virtual Environment
# ─────────────────────────────────────────────
echo "Creating Python virtual environment..."
python3 -m venv /home/ubuntu/venv
source /home/ubuntu/venv/bin/activate

# ─────────────────────────────────────────────
# Install Python Dependencies
# ─────────────────────────────────────────────
echo "Installing Python packages into virtual environment..."
pip install --upgrade pip
pip install flask psycopg2-binary boto3

# ─────────────────────────────────────────────
# Clone Your Flask App from GitHub
# ─────────────────────────────────────────────
echo "Cloning application repo..."
cd /home/ubuntu

if ! git clone https://github.com/Kedlyman/terraform-flask-app-clitasker-recreated.git app; then
  echo "Failed to clone Flask app repo. Aborting."
  exit 1
fi

cd app

# ─────────────────────────────────────────────
# Fetch Secrets from AWS Secrets Manager
# ─────────────────────────────────────────────
echo "Fetching secrets from Secrets Manager..."
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id aws-cli-project-db-password-2 \
  --query SecretString \
  --output text \
  --region eu-central-1)

export DB_USER=$(echo "$SECRET_JSON" | jq -r .username)
export DB_PASS=$(echo "$SECRET_JSON" | jq -r .password)

if [[ -z "$DB_USER" || -z "$DB_PASS" ]]; then
  echo "[ERROR] Failed to retrieve DB credentials. Aborting."
  exit 1
fi

# ─────────────────────────────────────────────
# Fetch RDS Endpoint
# ─────────────────────────────────────────────
echo "Fetching RDS endpoint..."
export DB_HOST=$(aws rds describe-db-instances \
  --db-instance-identifier terraform-flask-app-db \
  --query "DBInstances[0].Endpoint.Address" \
  --output text \
  --region eu-central-1)

export DB_NAME="postgres"

# ─────────────────────────────────────────────
# Fetch S3 Bucket Name 
# ─────────────────────────────────────────────
echo "Finding S3 bucket..."
export S3_BUCKET=$(aws s3api list-buckets \
  --query "Buckets[?starts_with(Name, 'terraform-flask-app-bucket')].Name | [0]" \
  --output text)

if [[ "$S3_BUCKET" == "None" || -z "$S3_BUCKET" ]]; then
  echo "S3 bucket not found. Aborting."
  exit 1
fi

# ─────────────────────────────────────────────
# Run the Flask App in Background
# ─────────────────────────────────────────────
echo "Starting Flask app..."

export FLASK_APP=app.app:app 
export FLASK_RUN_PORT=80   

nohup /home/ubuntu/venv/bin/flask run --host=0.0.0.0 --port=$FLASK_RUN_PORT > /var/log/terraform-flask-app.log 2>&1 &

sleep 5

if curl -fs http://localhost:$FLASK_RUN_PORT >/dev/null; then
  echo "Flask app is running!"
else
  echo "Flask app may not have started properly. Check the logs at /var/log/terraform-flask-app.log"
fi
