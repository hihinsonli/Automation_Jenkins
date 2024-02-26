pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'ap-southeast-2'
        ATHENA_DATABASE = 'cloudtrail_logs_db'
        S3_BUCKET_FOR_RESULTS = 's3://hinson-account-user-activitiy-athena-result/'
        PYTHON_SCRIPT_PATH = '../../python/visualize_data.py'
        AWS_CREDENTIALS_ID = 'aws_access_credential'
    }
    stages {
        stage('Query CloudTrail Logs') {
            steps {
                script {
                    // Example Athena query command. Adjust the SQL to fit your needs.
                    env.QUERY_EXECUTION_ID = sh(script: """
                    aws athena start-query-execution \
                    --query-string "SELECT eventName, userIdentity.username, COUNT(*) as count FROM ${ATHENA_DATABASE}.cloudtrail_logs WHERE eventTime BETWEEN '2023-01-01T00:00:00Z' AND '2023-12-31T23:59:59Z' GROUP BY eventName, userIdentity.username" \
                    --result-configuration OutputLocation=${S3_BUCKET_FOR_RESULTS} \
                    --query-execution-context Database=${ATHENA_DATABASE} \
                    --output text
                    """, returnStdout: true).trim()
                }
            }
        }
        stage('Check Query Execution') {
            steps {
                script {
                    // Poll Athena query execution status until it is SUCCEEDED, FAILED, or CANCELLED
                    sh "python3 check_athena_query_status.py ${env.QUERY_EXECUTION_ID}"
                }
            }
        }
        stage('Visualize Data') {
            steps {
                script {
                    sh "python3 visualize_cloudtrail_data.py ${env.QUERY_EXECUTION_ID}"
                }
            }
        }
        stage('Cleanup') {
            steps {
                deleteDir()
            }
        }
    }

    post {
        always {
            cleanWs(cleanWhenAborted: true,
                    cleanWhenFailure: true,
                    cleanWhenNotBuilt: true,
                    cleanWhenSuccess: true,
                    cleanWhenUnstable: true,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true)
        }
    }
}
