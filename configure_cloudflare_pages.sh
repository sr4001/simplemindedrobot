#!/bin/bash

# Cloudflare API configuration
API_TOKEN="${CLOUDFLARE_API_TOKEN}"
ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID}"
PROJECT_NAME="${CLOUDFLARE_PROJECT_NAME}"

# Check if required environment variables are set
if [ -z "$API_TOKEN" ] || [ -z "$ACCOUNT_ID" ] || [ -z "$PROJECT_NAME" ]; then
    echo "Error: Required environment variables are not set."
    echo "Please ensure CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, and CLOUDFLARE_PROJECT_NAME are set."
    exit 1
fi

# Function to make API calls
cf_api_call() {
    local method=$1
    local endpoint=$2
    local data=$3

    curl -X $method "https://api.cloudflare.com/client/v4$endpoint" \
         -H "Authorization: Bearer $API_TOKEN" \
         -H "Content-Type: application/json" \
         ${data:+-d "$data"}
}

# Update project settings
update_project_settings() {
    local data='{
        "build_config": {
            "build_command": "npm run build",
            "destination_dir": "public",
            "root_dir": ""
        },
        "deployment_configs": {
            "preview": {
                "environment_variables": {
                    "NODE_VERSION": "22.9.0",
                    "NPM_VERSION": "10.8.3",
                    "HUGO_VERSION": "0.135.0"
                }
            },
            "production": {
                "environment_variables": {
                    "NODE_VERSION": "22.9.0",
                    "NPM_VERSION": "10.8.3",
                    "HUGO_VERSION": "0.135.0"
                }
            }
        }
    }'

    cf_api_call PATCH "/accounts/$ACCOUNT_ID/pages/projects/$PROJECT_NAME" "$data"
}

# Main execution
echo "Updating Cloudflare Pages project settings..."
update_project_settings

echo "Configuration complete. Please check the output for any errors."
