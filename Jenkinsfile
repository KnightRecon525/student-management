pipeline {
    agent any

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
    }
}
