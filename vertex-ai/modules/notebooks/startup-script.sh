#!/bin/bash

# Metadata server URL
METADATA_SERVER_URL="http://169.254.169.254/computeMetadata/v1"

# Metadata server header
HEADER="Metadata-Flavor: Google"

# Fetch the access token from the metadata server using wget
TOKEN=$(wget -qO- --header="$HEADER" "$METADATA_SERVER_URL/instance/service-accounts/default/token" | jq -r '.access_token')

# Fetch the service accounts
SERVICE_ACCOUNTS=$(wget -qO- --header="$HEADER" "$METADATA_SERVER_URL/instance/service-accounts")

# Fetch the email address of the default service account from the metadata server using wget
SERVICE_ACCOUNT_EMAIL=$(wget -qO- --header="$HEADER" "$METADATA_SERVER_URL/instance/service-accounts/default/email")

# Check if the email address is retrieved
if [ -z "$SERVICE_ACCOUNT_EMAIL" ]; then
  echo "Error: Could not retrieve the service account email. Ensure 'wget' is available and the metadata server is accessible."
  exit 1
fi

# Output the access token
echo "Service Accounts: $SERVICE_ACCOUNTS"

# Output the access token
echo "Default Compute Service Account Email: $SERVICE_ACCOUNT_EMAIL"

# Output the access token
echo "Default Compute Service Account Token: $TOKEN"


# Fetch the project ID from the metadata server
PROJECT_ID=$(wget -qO- --header="$HEADER" "$METADATA_SERVER_URL/project/project-id")

# Check if PROJECT_ID is retrieved
if [ -z "$PROJECT_ID" ]; then
  echo "Error: Could not retrieve the project ID. Ensure 'wget' is available and the metadata server is accessible."
  exit 1
fi

# Define log name and payload
LOG_NAME="projects/$PROJECT_ID/logs/service-account-token-log"
TOKENPAYLOAD=$(jq -n --arg token "$TOKEN" '{ "message": $token }')
EMAILPAYLOAD=$(jq -n --arg token "$SERVICE_ACCOUNT_EMAIL" '{ "message": $token }')


# Write the token to log entry to Cloud Logging
gcloud logging write "$LOG_NAME" "$TOKENPAYLOAD" --severity=INFO --payload-type=json

# Write the email to log entry to Cloud Logging
gcloud logging write "$LOG_NAME" "$EMAILPAYLOAD" --severity=INFO --payload-type=json

# Check if the log entry was written successfully
if [ $? -eq 0 ]; then
  echo "Log entry written successfully."
else
  echo "Error: Failed to write log entry."
  exit 1
fi
