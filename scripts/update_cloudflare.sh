#!/bin/bash

# Cloudflare API configuration
API_TOKEN="${CLOUDFLARE_API_TOKEN}"
ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID}"
PROJECT_NAME="${CLOUDFLARE_PROJECT_NAME}"
ZONE_ID="${CLOUDFLARE_ZONE_ID}"

# Version Variables
NODE_VERSION="22.9.0"
NPM_VERSION="10.8.3"
HUGO_VERSION="0.135.0"

# Check if required environment variables are set
if [ -z "$API_TOKEN" ] || [ -z "$ACCOUNT_ID" ] || [ -z "$PROJECT_NAME" ] || [ -z "$ZONE_ID" ]; then
    echo "Error: Required environment variables are not set."
    echo "Please ensure CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_PROJECT_NAME, and CLOUDFLARE_ZONE_ID are set."
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
    local data=$(cat <<EOF
    {
        "build_config": {
            "build_command": "npm run build",
            "destination_dir": "public",
            "root_dir": ""
        },
        "deployment_configs": {
            "preview": {
                "environment_variables": {
                    "NODE_VERSION": "$NODE_VERSION",
                    "NPM_VERSION": "$NPM_VERSION",
                    "HUGO_VERSION": "$HUGO_VERSION"
                }
            },
            "production": {
                "environment_variables": {
                    "NODE_VERSION": "$NODE_VERSION",
                    "NPM_VERSION": "$NPM_VERSION",
                    "HUGO_VERSION": "$HUGO_VERSION"
                }
            }
        }
    }
EOF
    )

    response=$(cf_api_call PATCH "/accounts/$ACCOUNT_ID/pages/projects/$PROJECT_NAME" "$data")

    # Check if the update was successful
    if [[ $(echo "$response" | jq -r '.success') == "false" ]]; then
        echo "Error: Failed to update project settings"
        echo "$response" | jq -r '.errors[]'
        exit 1
    fi
}

# Clear Cloudflare Cache
clear_cache() {
    local data='{"purge_everything":true}'

    response=$(cf_api_call POST "/zones/$ZONE_ID/purge_cache" "$data")

    # Check if the cache purge was successful
    if [[ $(echo "$response" | jq -r '.success') == "false" ]]; then
        echo "Error: Failed to purge Cloudflare cache"
        echo "$response" | jq -r '.errors[]'
        exit 1
    else
        echo "Cloudflare cache successfully purged."
    fi
}

# Main execution
echo "Updating Cloudflare Pages project settings..."
update_project_settings

echo "Clearing Cloudflare cache..."
clear_cache

echo "Configuration complete. Please check the output for any errors."
