#!/bin/bash

# Cloudflare API configuration
API_TOKEN="${CLOUDFLARE_API_TOKEN}"
ACCOUNT_ID="${CLOUDFLARE_ACCOUNT_ID}"
PROJECT_NAME="${CLOUDFLARE_PROJECT_NAME}"
ZONE_ID="${CLOUDFLARE_ZONE_ID}"

# Read values from cloudflare.json
CLOUDFLARE_JSON="cloudflare.json"
BUILD_COMMAND=$(jq -r '.build.build_command' $CLOUDFLARE_JSON)
DESTINATION_DIR=$(jq -r '.build.destination_dir' $CLOUDFLARE_JSON)
ROOT_DIR=$(jq -r '.build.output_dir' $CLOUDFLARE_JSON)
NODE_VERSION=$(jq -r '.environment.NODE_VERSION' $CLOUDFLARE_JSON)
NPM_VERSION=$(jq -r '.environment.NPM_VERSION' $CLOUDFLARE_JSON)
HUGO_VERSION=$(jq -r '.environment.HUGO_VERSION' $CLOUDFLARE_JSON)

# Check if required environment variables are set
if [ -z "$API_TOKEN" ] || [ -z "$ACCOUNT_ID" ] || [ -z "$PROJECT_NAME" ] || [ -z "$ZONE_ID" ]; then
    echo "Error: Required environment variables are not set."
    echo "Please ensure CLOUDFLARE_API_TOKEN, CLOUDFLARE_ACCOUNT_ID, CLOUDFLARE_PROJECT_NAME, and CLOUDFLARE_ZONE_ID are set."
    exit 1
fi

# Function to make API calls

# cf_api_call() - Make a Cloudflare API call
#
# This function is used to make a Cloudflare API call. It takes three parameters:
# method (GET, PUT, POST, DELETE), endpoint, and data.
#
# The `data` parameter is optional and should be a JSON string.
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
# update_project_settings() - Update project settings
#
# This function updates the project settings for the specified project with the
# given environment variables. It takes no parameters.
#
# The function makes a PATCH request to the Cloudflare API to update the
# project settings. If the request is successful, it does nothing. If the request
# fails, it prints the error message to the console and exits with a status of 1.
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

# Clear Cloudflare Cache

# Clear the Cloudflare cache for the given zone.
#
# This function makes a POST request to the Cloudflare API to purge the cache for
# the given zone. If the purge is successful, it prints a success message. If the
# purge fails, it prints an error message and exits with status code 1.
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
