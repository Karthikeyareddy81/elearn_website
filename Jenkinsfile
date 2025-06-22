pipeline {
    agent any

    environment {
        TAR_NAME = 'elearn-website.tar.gz'
        ARTIFACT_DIR = 'elearn-website'
        NEXUS_URL = 'http://192.168.56.102:8081'
        NEXUS_REPO = 'webapp-releases'
        NEXUS_CREDS = credentials('nexus-creds') // Add these in Jenkins Credentials
        TOMCAT_SSH = 'tomcat-ssh'
        TOMCAT_IP = '192.168.56.102'
        TOMCAT_WEBAPPS = '/opt/tomcat/webapps'
    }

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'dev1', url: 'https://github.com/Karthikeyareddy81/elearn_website.git'
            }
        }

        stage('Build Artifact') {
            steps {
                sh '''
                cd elearn-website
                tar -czf ${TAR_NAME} *
                '''
            }
        }

        stage('Upload to Nexus') {
            steps {
                sh '''
                curl -v -u ${NEXUS_CREDS_USR}:${NEXUS_CREDS_PSW} \
                --upload-file elearn-website/${TAR_NAME} \
                ${NEXUS_URL}/repository/${NEXUS_REPO}/${TAR_NAME}
                '''
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent (credentials: [TOMCAT_SSH]) {
                    sh '''
                    scp elearn-website/${TAR_NAME} root@${TOMCAT_IP}:/tmp/
                    ssh root@${TOMCAT_IP} <<EOF
                        mkdir -p ${TOMCAT_WEBAPPS}/elearn
                        tar -xzf /tmp/${TAR_NAME} -C ${TOMCAT_WEBAPPS}/elearn
                        rm -f /tmp/${TAR_NAME}
                    EOF
                    '''
                }
            }
        }
    }
}
