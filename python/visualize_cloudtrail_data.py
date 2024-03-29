import sys
import boto3
import pandas as pd
import matplotlib.pyplot as plt

query_execution_id = sys.argv[1]
s3_client = boto3.client('s3')
athena_client = boto3.client('athena')

# Fetch query execution details to get the S3 path of the results
response = athena_client.get_query_execution(QueryExecutionId=query_execution_id)
s3_path = response['QueryExecution']['ResultConfiguration']['OutputLocation']

bucket, key = s3_path.replace("s3://", "").split('/', 1)
obj = s3_client.get_object(Bucket=bucket, Key=key)
df = pd.read_csv(obj['Body'])
print(df.columns)

# Plotting
df.groupby('username')['eventName'].count().plot(kind='bar')
plt.title('AWS Actions per User')
plt.xlabel('User Name')
plt.ylabel('Number of Actions')
plt.savefig('actions_per_user.png')
plt.show()
