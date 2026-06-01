pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        ECR_REPO   = 'facebook-application'
        ACCOUNT_ID = '848004113365'
        IMAGE_TAG  = "${BUILD_NUMBER}"
        IMAGE_URI  = "${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
    }

    stages {

        // ✅ Clean workspace (prevents issues from previous builds)
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'develop',   // ✅ FIX: match your GitHub branch
                    url: 'https://github.com/manju230/facebook-application.git'
            }
        }

        stage('Verify Files') {
            steps {
                sh '''
                echo "Current directory:"
                pwd
                echo "Files in workspace:"
                ls -l
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh """
                aws ecr get-login-password --region ${AWS_REGION} \
                | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build --no-cache -t ${IMAGE_URI} .
                """
            }
        }

        stage('Push to ECR') {
            steps {
                sh """
                docker push ${IMAGE_URI}
                """
            }
        }
    }

    post {
        success {
            echo "✅ Image pushed successfully: ${IMAGE_URI}"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
