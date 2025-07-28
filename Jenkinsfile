// Jenkinsfile #helldearo
pipeline {
    agent any

    environment {
        // Define your Docker Hub repository names
        DOCKER_HUB_DEV_REPO = 'arundiv/devops-build-task-dev'
        DOCKER_HUB_PROD_REPO = 'arundiv/devops-build-task-prod'
        // Define the name of the Docker container on the application server
        APP_CONTAINER_NAME = 'devops-app'
        // IP address or hostname of your Application Server (Instance 2)
        APP_SERVER_IP = '65.0.125.165' // <--- IMPORTANT: REPLACE THIS
        // SSH username for connecting to the Application Server
        APP_SERVER_USER = 'ubuntu' // <--- IMPORTANT: Verify this is the correct SSH user
        // Jenkins credential ID for SSH connection to Application Server
        SSH_CREDENTIAL_ID = 'app-server-ssh-key' // <--- IMPORTANT: You will create this in Jenkins
    }

    stages {
        stage('Checkout Source Code') {
            steps {
                echo "Checking out source code from Git..."
                // This 'checkout scm' step is implicitly handled by Jenkins pipeline
                // if configured correctly in the job settings (Pipeline script from SCM).
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def imageRepo = ""
                    def imageTag = env.BUILD_NUMBER // Using Jenkins build number as tag

                    if (env.BRANCH_NAME == 'main') {
                        imageRepo = "${env.DOCKER_HUB_PROD_REPO}"
                    } else {
                        imageRepo = "${env.DOCKER_HUB_DEV_REPO}"
                    }
                    
                    env.BUILT_IMAGE_FULL_NAME = "${imageRepo}:${imageTag}"
                    
                    // --- CALLING build.sh HERE ---
                    sh "IMAGE_NAME=${env.BUILT_IMAGE_FULL_NAME} ./build.sh"
                    echo "Docker image built: ${env.BUILT_IMAGE_FULL_NAME}"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Get Docker Hub credentials from Jenkins
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        // Push the image to the appropriate repository
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                        sh "docker push ${env.BUILT_IMAGE_FULL_NAME}"
                        echo "Docker image pushed: ${env.BUILT_IMAGE_FULL_NAME}"
                    }
                }
            }
        }

        stage('Deploy to Application Server') {
            steps {
                script {
                    // Use the sshagent step to automatically load the SSH key
                    withCredentials([sshUserPrivateKey(credentialsId: env.SSH_CREDENTIAL_ID, keyFileVariable: 'SSH_KEY')]) {
                        // Pass environment variables and execute the deploy.sh script on the remote application server via SSH
                        def remoteCommand = """
                            export IMAGE_NAME='${env.BUILT_IMAGE_FULL_NAME}'
                            export CONTAINER_NAME='${env.APP_CONTAINER_NAME}'
                            /home/${env.APP_SERVER_USER}/Docker/devops-build/deploy.sh
                        """
                        sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${env.APP_SERVER_USER}@${env.APP_SERVER_IP} '${remoteCommand}'"
                    }
                }
            }
        }
    }
}
