pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'master',
                    url: 'https://github.com/mwsriram/2048.git'
            }
        }

        stage('Build & Run Container (master only)') {
            when {
                branch 'master'
            }
            steps {
                sh """
                    echo 'Building Docker image...'
                    docker build -t 2048-game .

                    echo 'Stopping old container if exists...'
                    docker rm -f 2048-container || true

                    echo 'Running new container...'
                    docker run -d --name 2048-container -p 80:80 2048-game
                """
            }
        }
    }
}
