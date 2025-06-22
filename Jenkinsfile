pipeline {
    agent any

    environment {
        TAR_NAME = 'elearn-website.tar.gz'
        ARTIFACT_DIR = 'elearn-website'
        NEXUS_URL = 'http://192.168.56.102:8081'
        NEXUS_REPO = 'webapp-releases'
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
                    echo "[INFO] Creating tar.gz..."
                    tar -czf ${TAR_NAME} elearn-website/
                    ls -lh ${TAR_NAME}
                '''
            }
        }

        stage('Upload to Nexus') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'nexus-creds', usernameVariable: 'NEXUS_USER', passwordVariable: 'NEXUS_PASS')]) {
                    sh '''
                        echo "[INFO] Uploading ${TAR_NAME} to Nexus..."
                        ls -lh ${TAR_NAME}
                        curl -v -u $NEXUS_USER:$NEXUS_PASS \
                        --upload-file ${TAR_NAME} \
                        ${NEXUS_URL}/repository/${NEXUS_REPO}/${TAR_NAME}
                    '''
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sshagent (credentials: [TOMCAT_SSH]) {
                    sh '''
                        echo "[INFO] Copying ${TAR_NAME} to Tomcat server..."
                        scp ${TAR_NAME} root@${TOMCAT_IP}:/tmp/

                        echo "[INFO] Extracting and deploying on Tomcat..."
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
