pipeline {
    agent any

    triggers {
        // Trigger automatically when code is pushed to GitHub (webhook required)
        githubPush()
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Fetching latest code from GitHub...'
                git branch: 'master', url: 'git@github.com:mwsriram/2048.git', credentialsId: 'github-ssh-key'
            }
        }

        stage('Build') {
            steps {
                echo 'Running existing Jenkins build steps...'
                // If your Jenkins job already has a build command configured,
                // you can trigger it here or leave this empty
                sh './build.sh'  // optional – remove if Jenkins handles it
            }
        }
    }

    post {
        success {
            echo '✅ Build successful!'
        }
        failure {
            echo '❌ Build failed. Check logs for details.'
        }
    }
}
