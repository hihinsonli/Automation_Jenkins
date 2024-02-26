#!/bin/bash

# Define tags
TAG_KEY1="Key1"
TAG_VALUE1="Value1"
TAG_KEY2="Key2"
TAG_VALUE2="Value2"
# Add more tags as needed

# List log groups and filter by name containing "string", then tag them
aws logs describe-log-groups --query 'logGroups[?contains(logGroupName, `string`)].logGroupName' --output text | while IFS=$'\t' read -r logGroupName; do
    echo "Tagging log group: $logGroupName"
    aws logs tag-log-group --log-group-name "$logGroupName" --tags "$TAG_KEY1"="$TAG_VALUE1" "$TAG_KEY2"="$TAG_VALUE2"
    # Repeat --tags for each additional tag
done

echo "Tagging complete."
