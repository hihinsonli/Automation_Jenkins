pipeline {
    agent any

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
            steps {
                dir('hinson-ray-portfolio') {
                    sh 'npm install'
                    sh 'npm install sass'
                }
            }
        }

        stage('Build') {
            steps {
                dir('hinson-ray-portfolio') {
                    sh 'npm run build'
                }
            }
        }

        stage('Deploy to AWS S3') {
            steps {
                dir('hinson-ray-portfolio/build') {
                    withAWS(credentials: '${AWS_CREDENTIALS_ID}', region: '${AWS_REGION}') {
                        s3Upload(bucket: '${S3_BUCKET}', file: '.', includePathPattern: '**/*', workingDir: '.', acl: 'PublicRead')
                    }
                }
            }
        }
    }
}
