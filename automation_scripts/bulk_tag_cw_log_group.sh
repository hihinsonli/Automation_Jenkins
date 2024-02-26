##################
Use case:
The AWS Tag Editor does not offer functionality for bulk tagging CloudWatch log groups. 
To address this limitation, the provided shell script facilitates tagging log groups that share a common substring in their names. 
The script operates with partial automation, allowing the addition of a single tag per script execution.
##################

#!/bin/bash

# Define tags
TAG_KEY1="Key1"
TAG_VALUE1="Value1"
TAG_KEY2="Key2"
TAG_VALUE2="Value2"
# Add more key-value pairs as needed

# Get list of log group names containing "string" and read them line by line
aws logs describe-log-groups --query 'logGroups[?contains(logGroupName, `string`)].logGroupName' --output text | while IFS=$'\t' read -r logGroupName; do
    # Split the output into individual log group names and tag them
    for name in $logGroupName; do
        echo "Tagging log group: $name"
        aws logs tag-log-group --log-group-name "$name" --tags "$TAG_KEY1"="$TAG_VALUE1"
        # Add additional tags as needed
    done
done

echo "Tagging complete."
