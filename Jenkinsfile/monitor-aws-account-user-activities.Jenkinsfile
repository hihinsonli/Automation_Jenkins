pipeline {
    agent any
    environment {
        AWS_REGION = 'ap-southeast-2'
        ATHENA_DATABASE = 'cloudtrail_logs_db'
        S3_BUCKET_FOR_RESULTS = 's3://hinson-account-user-activitiy-athena-result/CloudTrail-logs/Unsaved/'
        PYTHON_SCRIPT_PATH = 'python/visualize_cloudtrail_data.py'
        AWS_CREDENTIALS_ID = 'aws_access_credential'
    }
    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/hihinsonli/Automation_Jenkins.git',
                   branch: 'main',
                   credentialsId: 'github-credentials-id'
            }
        }
        stage('Query CloudTrail Logs') {
            steps {
                script {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}", region: "${AWS_REGION}") {
                        env.QUERY_EXECUTION_ID = sh(script: """
                        aws athena start-query-execution \
                        --query-string "SELECT eventName, userIdentity.username, COUNT(*) as count FROM ${ATHENA_DATABASE}.cloudtrail_logs WHERE eventTime BETWEEN '2024-02-01T00:00:00Z' AND '2024-02-27T23:59:59Z' GROUP BY eventName, userIdentity.username" \
                        --result-configuration OutputLocation=${S3_BUCKET_FOR_RESULTS} \
                        --query-execution-context Database=${ATHENA_DATABASE} \
                        --output text
                        """, returnStdout: true).trim()
                    }
                }
            }
        }
        stage('Check Query Execution') {
            steps {
                script {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}", region: "${AWS_REGION}") {
                        // Update the path to the check_athena_query_status.py script
                        sh "python3 python/check_athena_query_status.py ${env.QUERY_EXECUTION_ID}"
                    }
                }
            }
        }
        stage('Visualize Data') {
            steps {
                script {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}", region: "${AWS_REGION}") {
                        // Use the PYTHON_SCRIPT_PATH environment variable
                        sh "python3 ${PYTHON_SCRIPT_PATH} ${env.QUERY_EXECUTION_ID}"
                    }
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
