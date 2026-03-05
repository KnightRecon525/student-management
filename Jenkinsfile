pipeline {
    agent any

    // Define variables used throughout the pipeline
    environment {
        DOCKER_IMAGE = "your-dockerhub-username/student-management"
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

        // NEW: Build the Docker image using your Dockerfile
        stage('Docker Build') {
            steps {
                echo 'Construction de l image Docker...'
                sh "docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} ."
            }
        }

        // NEW: Log in to DockerHub and push the image
       stage('Docker Push') {
           steps {
               echo 'Push de l image vers DockerHub...'
               withCredentials([usernamePassword(
                         credentialsId: 'dockerhub-credentials',
                         usernameVariable: 'dali628',
                         passwordVariable: '!78GFp?LJsJW6_$'
               )]) {
                   script {
                       // Store in local Groovy variables first
                       def dockerUser = env.DOCKER_USER
                       def dockerPass = env.DOCKER_PASS

                       // Now use them safely in sh with double quotes
                       sh """
                           echo '${dockerPass}' | docker login -u '${dockerUser}' --password-stdin
                           docker push ${DOCKER_IMAGE}:${DOCKER_TAG}
                           docker logout
                       """
                   }
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