import sys
import time
import boto3

query_execution_id = sys.argv[1]
# Specify the region directly
client = boto3.client('athena', region_name='ap-southeast-2')

while True:
    response = client.get_query_execution(QueryExecutionId=query_execution_id)
    status = response['QueryExecution']['Status']['State']
    if status in ['SUCCEEDED', 'FAILED', 'CANCELLED']:
        print(f"Query {status}")
        break
    else:
        print("Query still running...")
    time.sleep(5)  # Poll every 5 seconds
