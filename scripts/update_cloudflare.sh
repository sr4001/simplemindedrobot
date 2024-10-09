#!/bin/bash

# Cloudflare API configuration (saved in GitHub secrets)
API_TOKEN="${CLOUDFLARE_API_TOKEN}"        # Authentication token for Cloudflare API
ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID}"      # Cloudflare account ID
PROJECT_NAME="${CLOUDFLARE_PROJECT_NAME}"  # Name of the Cloudflare Pages project
ZONE_ID="${CLOUDFLARE_ZONE_ID}"            # ID of the Cloudflare zone (domain)

# Define local variables for build and environment settings
BUILD_COMMAND="npm run build"  # Command to build the project
DESTINATION_DIR="public"       # Directory where build output is stored
ROOT_DIR=""                    # Root directory of the project (empty means current directory)
NODE_VERSION="16.13.0"         # Version of Node.js to use
NPM_VERSION="8.1.0"            # Version of npm to use
HUGO_VERSION="0.88.1"          # Version of Hugo to use (if applicable)

# Check if required environment variables are set
if [ -z "$API_TOKEN" ] || [ -z "$ACCOUNT_ID" ] || [ -z "$PROJECT_NAME" ] || [ -z "$ZONE_ID" ]; then
    echo "Error: Required environment variables are not set."
    echo "Please ensure CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_PROJECT_NAME, and CLOUDFLARE_ZONE_ID are set."
    exit 1
fi

# Function to make API calls to Cloudflare
#
# Parameters:
# $1: HTTP method (GET, PUT, POST, DELETE)
# $2: API endpoint
# $3: JSON data (optional)
#
# This function constructs and sends HTTP requests to the Cloudflare API
# using the provided parameters and authentication token.
cf_api_call() {
    local method=$1
    local endpoint=$2
    local data=$3

    curl -X $method "https://api.cloudflare.com/client/v4$endpoint" \
         -H "Authorization: Bearer $API_TOKEN" \
         -H "Content-Type: application/json" \
         ${data:+-d "$data"}
}

# Function to update project settings
#
# This function updates the Cloudflare Pages project settings including
# build configuration and environment variables for both preview and
# production deployments.
update_project_settings() {
    local data=$(cat <<EOF
    {
        "build_config": {
            "build_command": "$BUILD_COMMAND",
            "destination_dir": "$DESTINATION_DIR",
            "root_dir": "$ROOT_DIR"
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

# Function to clear Cloudflare cache
#
# This function sends a request to Cloudflare to purge the entire cache
# for the specified zone (domain). It's useful after deploying updates
# to ensure that the latest version of the site is served to visitors.
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
