pipeline {
    agent any
    
    environment {
        DOCKER_USERNAME = 'arundiv'
        DOCKER_PASSWORD = 'Kamalamarimuthu'
        GITHUB_REPO = 'https://github.com/sriram-R-krishnan/devops-build'
        DOCKER_IMAGE_PREFIX = 'arundiv'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo '📥 Checking out code...'
                git branch: "${env.BRANCH_NAME ?: 'master'}", url: "${GITHUB_REPO}"
            }
        }
        
        stage('Verify Build') {
            steps {
                echo '🔍 Verifying React build exists...'
                sh '''
                    if [ -d "build" ]; then
                        echo "✅ Build directory found"
                        ls -la build/
                    else
                        echo "❌ Build directory not found"
                        exit 1
                    fi
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    def imageTag = "${env.BRANCH_NAME ?: 'master'}-${env.BUILD_NUMBER}"
                    def repoName = (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == null) ? 'prod' : 'dev'
                    
                    echo "🏗️ Building Docker image: ${DOCKER_IMAGE_PREFIX}/${repoName}:${imageTag}"
                    
                    sh """
                        docker build -t ${DOCKER_IMAGE_PREFIX}/${repoName}:${imageTag} .
                        docker tag ${DOCKER_IMAGE_PREFIX}/${repoName}:${imageTag} ${DOCKER_IMAGE_PREFIX}/${repoName}:latest
                    """
                }
            }
        }
        
        stage('Test Container') {
            steps {
                script {
                    def repoName = (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == null) ? 'prod' : 'dev'
                    
                    echo '🧪 Testing container...'
                    sh """
                        # Run container for testing
                        docker run --rm -d -p 8080:80 --name test-container ${DOCKER_IMAGE_PREFIX}/${repoName}:latest
                        
                        # Wait for container to be ready
                        echo "⏳ Waiting for container to start..."
                        sleep 10
                        
                        # Test health endpoint
                        echo "🏥 Testing health endpoint..."
                        if curl -f http://localhost:8080/health; then
                            echo '✅ Health check passed!'
                        else
                            echo '❌ Health check failed!'
                            docker logs test-container
                            exit 1
                        fi
                        
                        # Test main page
                        echo "🌐 Testing main page..."
                        if curl -f http://localhost:8080/ > /dev/null; then
                            echo '✅ Main page accessible!'
                        else
                            echo '❌ Main page not accessible!'
                            exit 1
                        fi
                        
                        # Cleanup
                        docker stop test-container
                    """
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    def imageTag = "${env.BRANCH_NAME ?: 'master'}-${env.BUILD_NUMBER}"
                    def repoName = (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == null) ? 'prod' : 'dev'
                    
                    echo "📤 Pushing to Docker Hub..."
                    
                    sh """
                        echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin
                        docker push ${DOCKER_IMAGE_PREFIX}/${repoName}:${imageTag}
                        docker push ${DOCKER_IMAGE_PREFIX}/${repoName}:latest
                    """
                }
            }
        }
        
        stage('Deploy') {
            when {
                anyOf {
                    branch 'master'
                    branch 'main'
                }
            }
            steps {
                echo '🚀 Deploying to production...'
                sh 'chmod +x deploy.sh && ./deploy.sh'
            }
        }
    }
    
    post {
        always {
            sh 'docker logout'
            sh 'docker system prune -f'
        }
        success {
            echo '✅ Pipeline completed successfully!'
            echo "🌐 Your React app is deployed and running!"
        }
        failure {
            echo '❌ Pipeline failed!'
            sh 'docker ps -a'
            sh 'docker logs test-container || true'
        }
    }
}
