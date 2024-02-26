#!/bin/bash

# Define tags
TAG_KEY1="Key1"
TAG_VALUE1="Value1"
TAG_KEY2="Key2"
TAG_VALUE2="Value2"
# Add more tags as needed

# Get list of log group names containing "string"
readarray -t logGroupNames < <(aws logs describe-log-groups --query 'logGroups[?contains(logGroupName, `string`)].logGroupName' --output text)

# Tag each log group individually
for logGroupName in "${logGroupNames[@]}"; do
    echo "Tagging log group: $logGroupName"
    aws logs tag-log-group --log-group-name "$logGroupName" --tags "$TAG_KEY1"="$TAG_VALUE1"
    # Add additional tags as needed
done

echo "Tagging complete."
