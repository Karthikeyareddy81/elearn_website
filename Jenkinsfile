pipeline {
    agent any  // Runs on any available Jenkins agent

    environment {
        IMAGE_NAME = "my-static-site"
        DOCKER_REGISTRY = "karthikeyareddy716/my-static-site"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/Karthikeyareddy81/elearn_website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh 'docker tag $IMAGE_NAME $DOCKER_REGISTRY:latest'
                    sh 'docker push $DOCKER_REGISTRY:latest'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
