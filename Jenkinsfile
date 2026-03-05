pipeline {
    agent any

    environment {
        // ⚠️ Replace dali628 with your actual DockerHub username here only
        DOCKER_IMAGE = "dali628/student-management"
        DOCKER_TAG = "latest"
    }

    stages {

        stage('Checkout GIT') {
            steps {
                echo 'Recuperation du code...'
                git branch: 'main',
                    url: 'https://github.com/KnightRecon525/student-management.git'
            }
        }

        stage('Compilation Maven') {
            steps {
                sh 'mvn -version'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Construction de l image Docker...'
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                echo 'Push de l image vers DockerHub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh(script: 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin')
                    sh(script: "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}")
                    sh(script: 'docker logout')
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline terminé avec succès! Image disponible sur DockerHub.'
        }
        failure {
            echo 'Le pipeline a échoué.'
        }
    }
}