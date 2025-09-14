pipeline {
    agent any

    environment {
        TAR_NAME = 'elearn-website.tar.gz'
        ARTIFACT_DIR = 'elearn-website'
        NEXUS_URL = 'http://192.168.56.102:8081'
        NEXUS_REPO = 'webapp-releases'
        NEXUS_CREDS = credentials('nexus-creds')
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
                # Create tar.gz directly in workspace
                tar -czf ${TAR_NAME} -C ${ARTIFACT_DIR} .
                '''
            }
        }

        stage('Upload to Nexus') {
            steps {
                sh '''
                echo "Uploading: ${TAR_NAME} to Nexus..."
                ls -lh ${TAR_NAME}
                curl -v -u ${NEXUS_CREDS_USR}:${NEXUS_CREDS_PSW} \
                --upload-file ${TAR_NAME} \
                ${NEXUS_URL}/repository/${NEXUS_REPO}/${TAR_NAME}
                '''
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent (credentials: [TOMCAT_SSH]) {
                    sh '''
                    scp ${TAR_NAME} root@${TOMCAT_IP}:/tmp/
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
