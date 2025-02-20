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
                // Set Kubernetes config to use your master node's kubeconfig
                sh 'export KUBECONFIG=/etc/kubernetes/admin.conf'
        
                // Apply the deployment file to your cluster
                sh 'kubectl apply -f deployment.yaml'
        
                // Optional: Verify deployment status
                sh 'kubectl rollout status deployment/my-static-site'
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
