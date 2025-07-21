// Jenkinsfile
pipeline {
    agent any

    environment {
        // Define your Docker Hub repository names
        DOCKER_HUB_DEV_REPO = 'arundiv/devops-build-task-dev'
        DOCKER_HUB_PROD_REPO = 'arundiv/devops-build-task-prod'
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Checking out from Git..."
            }
        }

        stage('Build Image') {
            steps {
                script {
                    def imageName = ""
                    // Use a unique tag for the Docker image
                    if (env.BRANCH_NAME == 'main') {
                        imageName = "${env.DOCKER_HUB_PROD_REPO}:${env.BUILD_NUMBER}"
                    } else {
                        imageName = "${env.DOCKER_HUB_DEV_REPO}:${env.BUILD_NUMBER}"
                    }
                    
                    // Build the Docker image from the build folder
                    sh "docker build -t ${imageName} ./build"
                    
                    // Store the image name for the next stage
                    env.BUILT_IMAGE_NAME = imageName
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
                        sh "docker push ${env.BUILT_IMAGE_NAME}"
                    }
                }
            }
        }
    }
}
