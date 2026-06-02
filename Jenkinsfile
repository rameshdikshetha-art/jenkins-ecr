pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'
        AWS_ACCOUNT_ID = '562931631663'
        ECR_REPO = 'developers-jenkins-deployment'

        IMAGE_TAG = "${BUILD_NUMBER}"
        IMAGE_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                url: 'https://github.com/rameshdikshetha-art/jenkins-ecr.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t developers-jenkins-deployment:${BUILD_NUMBER} .
                '''
            }
        }

        stage('Login to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 562931631663.dkr.ecr.ap-south-1.amazonaws.com
                '''
            }
        }

        stage('Tag Image') {
            steps {
                sh '''
                docker tag developers-jenkins-deployment:${BUILD_NUMBER} ${IMAGE_URI}:${BUILD_NUMBER}
                docker tag developers-jenkins-deployment:${BUILD_NUMBER} ${IMAGE_URI}:latest
                '''
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh '''
                docker push ${IMAGE_URI}:${BUILD_NUMBER}
                docker push ${IMAGE_URI}:latest
                '''
            }
        }
    }
}
