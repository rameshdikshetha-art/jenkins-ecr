pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'your-dockerhub-username'
        IMAGE_NAME   = 'facebook-application'
        IMAGE_TAG    = "${BUILD_NUMBER}"
        IMAGE_URI    = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
        DOCKER_CREDS = 'dockerhub-creds'   // Jenkins credentials ID
    }

    stages {

        // ✅ Clean workspace
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'develop',
                    url: 'https://github.com/rameshdikshetha-art/Jenkins-developers-deployment.git'
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

        stage('Login to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build --no-cache -t ${IMAGE_URI} .
                """
            }
        }

        stage('Push to Docker Hub') {
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