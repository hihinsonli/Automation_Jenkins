CREATE EXTERNAL TABLE IF NOT EXISTS cloudtrail_logs_db.cloudtrail_logs (
  eventVersion STRING,
  userIdentity STRUCT<type: STRING, principalId: STRING, arn: STRING, accountId: STRING, invokedBy: STRING, accessKeyId: STRING, userName: STRING, sessionContext: STRUCT<attributes: STRUCT<mfaAuthenticated: STRING, creationDate: STRING>, sessionIssuer: STRUCT<type: STRING, principalId: STRING, arn: STRING, accountId: STRING, userName: STRING>>>,
  eventTime STRING,
  eventSource STRING,
  eventName STRING,
  awsRegion STRING,
  sourceIPAddress STRING,
  userAgent STRING,
  errorCode STRING,
  errorMessage STRING,
  requestParameters STRING,
  responseElements STRING,
  additionalEventData STRING,
  requestId STRING,
  eventId STRING,
  readOnly BOOLEAN,
  resources ARRAY<STRUCT<ARN: STRING, accountId: STRING, type: STRING>>,
  eventType STRING,
  apiVersion STRING,
  recipientAccountId STRING,
  serviceEventDetails STRING,
  sharedEventID STRING,
  vpcEndpointId STRING
)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
)
LOCATION 's3://hinson-aws-cloudtrail-logs-25022024/AWSLogs/CloudTrail/';