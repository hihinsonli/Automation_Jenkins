pipeline {
    agent any

    parameters {
    booleanParam(name: 'ENABLE_BUILD',
                    defaultValue: true,
                    description: 'Enable npm build process.')
    }

    environment {
        AWS_CREDENTIALS_ID = 'aws_access_credential'
        S3_BUCKET = 'www.hinsonli.com'
        AWS_REGION = 'ap-southeast-2'
        AWS_ACCOUNT_ID = '154864927037'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/hihinsonli/hinson-ray-portfolio'
            }
        }

        stage('Prepare Environment') {
            when {
                beforeInput true
                environment name: 'ENABLE_BUILD', value: 'true'
            }
            steps {
                dir('hinson-ray-portfolio') {
                    sh 'npm install'
                    sh 'npm audit'
                    sh 'npm install sass'
                }
            }
        }

        stage('Build') {
            when {
                beforeInput true
                environment name: 'ENABLE_BUILD', value: 'true'
            }
            steps {
                dir('hinson-ray-portfolio') {
                    sh 'npm run build'
                }
            }
        }

        stage('Deploy to AWS S3') {
            steps {
                // Adjusted to the correct path
                dir('build') {
                    withAWS(credentials: "${AWS_CREDENTIALS_ID}", region: "${AWS_REGION}") {
                        s3Upload(bucket: "${S3_BUCKET}", includePathPattern: '**/*', workingDir: '.', acl: 'PublicRead')
                    }
                }
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
