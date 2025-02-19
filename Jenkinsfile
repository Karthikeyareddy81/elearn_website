pipeline {
    agent any  // Runs on any available Jenkins agent

    environment {
        IMAGE_NAME = "my-static-site"
        DOCKER_REGISTRY = "karthikeyareddy716/my-static-site"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Karthikeyareddy81/elearn_website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-cred', url: '']) {
                    sh 'docker tag $IMAGE_NAME $DOCKER_REGISTRY:latest'
                    sh 'docker push $DOCKER_REGISTRY:latest'
                }
            }
        }

        // stage('Deploy to Kubernetes') {
        //     steps {
        //         sh 'kubectl config use-context minikube'
        //         sh 'kubectl apply -f deployment.yaml'
        //     }
        // }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Check if Minikube is running
                    def minikubeStatus = sh(script: 'minikube status | grep -i running || echo "not running"', returnStdout: true).trim()
                    if (minikubeStatus.contains("not running")) {
                        error "Minikube is not running. Start Minikube before deploying."
                    }
        
                    // Ensure Minikube context is set
                    def currentContext = sh(script: 'kubectl config current-context || echo "no-context"', returnStdout: true).trim()
                    if (currentContext != "minikube") {
                        sh 'kubectl config use-context minikube'
                    }
        
                    // Apply Kubernetes manifests
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
      }

    }

    post {
        success {
            echo '✅ Deployment successful!'
        }
        failure {
            echo '❌ Deployment failed!'
        }
    }
}
