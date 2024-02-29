pipeline {
    agent any
    environment {
        AWS_S3_BUCKET = 'hinson-portfolio-ecosystem-backups'
        AWS_CREDENTIALS_ID = 'aws_access_credential'
    }
    stages {
        stage('Backup Databases') {
            steps {
                script {
                    // Define the base path for backups
                    def backupBasePath = '/var/jenkins_home/backup'
                    
                    // Generate a datetime string
                    def date = new Date()
                    def formattedDate = date.format('yyyyMMddHHmmss')
                    def hinsonBackupFileName = "${backupBasePath}/hinson_blog_db_dump_backup_${formattedDate}.sql"
                    def rayBackupFileName = "${backupBasePath}/ray_blog_db_dump_backup_${formattedDate}.sql"

                    // Use withCredentials to inject database credentials
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'ssh-key-credential-id', keyFileVariable: 'SSH_KEY_PATH'),
                        string(credentialsId: 'BLOG_DB_HINSON', variable: 'DB_HINSON'),
                        string(credentialsId: 'BLOG_DB_HINSON_PASSWORD', variable: 'DB_HINSON_PASS'),
                        string(credentialsId: 'BLOG_DB_RAY', variable: 'DB_RAY'),
                        string(credentialsId: 'BLOG_DB_RAY_PASSWORD', variable: 'DB_RAY_PASS')
                    ]) {
                        // Define environment variables for the command within withEnv
                        withEnv(["DB_HINSON=${DB_HINSON}", "DB_HINSON_PASS=${DB_HINSON_PASS}", "DB_RAY=${DB_RAY}", "DB_RAY_PASS=${DB_RAY_PASS}"]) {
                            // Use the environment variables in the command
                            sh '''
                            ssh -o StrictHostKeyChecking=no -i $SSH_KEY_PATH root@10.0.0.1 "docker exec hinson-blog mysqldump -u $DB_HINSON -p$DB_HINSON_PASS wordpress" > $hinsonBackupFileName
                            '''
                        }
                    }
                }
            }
        }

        stage('Upload to S3') {
            steps {
                script {
                    // Use withCredentials to inject AWS credentials
                    withCredentials([
                        [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: AWS_CREDENTIALS_ID, accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']
                    ]) {
                        // Upload the backups with datetime in their filenames to S3
                        sh "aws s3 cp ${hinsonBackupFileName} s3://${AWS_S3_BUCKET}/hinson-blog/${hinsonBackupFileName}"
                        sh "aws s3 cp ${rayBackupFileName} s3://${AWS_S3_BUCKET}/ray-blog/${rayBackupFileName}"
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
