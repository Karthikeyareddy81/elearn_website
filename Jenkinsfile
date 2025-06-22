pipeline {
    agent any

    environment {
        TAR_NAME = 'elearn-website.tar.gz'
        ARTIFACT_DIR = 'elearn-website'
        NEXUS_URL = 'http://192.168.56.102:8081'
        NEXUS_REPO = 'webapp-releases'
        NEXUS_CREDS = credentials('nexus-creds') // Add in Jenkins > Manage Credentials
        TOMCAT_SSH = 'tomcat-ssh'                // Add in Jenkins > Manage Credentials (SSH key)
        TOMCAT_IP = '192.168.56.102'
        TOMCAT_WEBAPPS = '/opt/tomcat/webapps'
    }

    stages {

        stage('Debug - Show Workspace') {
            steps {
                sh '''
                    echo "WORKSPACE = $WORKSPACE"
                    echo "Listing contents:"
                    ls -alh
                '''
            }
        }

        stage('Clone Code') {
            steps {
                git branch: 'dev1', url: 'https://github.com/Karthikeyareddy81/elearn_website.git'
            }
        }

        stage('Build Artifact') {
            steps {
                sh '''
                    tar -czf ${TAR_NAME} -C ${ARTIFACT_DIR} .
                    echo "Artifact created: ${TAR_NAME}"
                '''
            }
        }

        stage('Upload to Nexus') {
            steps {
                sh '''
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
