pipeline {
    agent any

    environment {
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

        // NEW: SonarQube code quality analysis
        stage('SonarQube Analysis') {
            steps {
                echo 'Analyse de la qualite du code avec SonarQube...'
                // 'SonarQube' must match exactly the name you set in Jenkins System config
                withSonarQubeEnv('SonarQube') {
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=student-management \
                        -Dsonar.projectName=student-management \
                        -Dsonar.host.url=http://192.168.50.4:9000
                    '''
                }
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
            echo 'Pipeline terminé avec succès! Rapport disponible sur SonarQube.'
        }
        failure {
            echo 'Le pipeline a échoué.'
        }
    }
}