#!/bin/bash

# Declare a 
declare -A TAGS=(
    ["Key1"]="Value1"
    ["Key2"]="Value2"
    ["Key3"]="Value3"
)

# Convert associative array to a string of tags for AWS CLI
TAGS_STR=""
for key in "${!TAGS[@]}"; do
    TAGS_STR="$TAGS_STR$key=${TAGS[$key]} "
done

# Trim trailing space
TAGS_STR=$(echo "$TAGS_STR" | xargs)

# List log groups and filter by name containing a particular "string", then tag them
aws logs describe-log-groups --query 'logGroups[?contains(logGroupName, `log_group_string`)].logGroupName' --output text | while read -r logGroupName; do
    echo "Tagging log group: $logGroupName with tags: $TAGS_STR"
    aws logs tag-log-group --log-group-name "$logGroupName" --tags $TAGS_STR
done

echo "Tagging complete."
