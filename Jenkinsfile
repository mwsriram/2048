pipeline {
    agent any

    triggers {
        // Automatically build on every push to GitHub (via webhook)
        githubPush()
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Checkout from GitHub using Jenkins SSH credentials
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/master']], // or master
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    userRemoteConfigs: [[
                        url: 'git@github.com:mwsriram/2048.git',
                        credentialsId: 'github-ssh-key' // <-- Jenkins SSH credential ID
                    ]]
                ])
            }
        }

        stage('Build') {
            steps {
                echo 'Building project...'
                sh 'ls -la'
            }
        }

        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy step goes here...'
            }
        }
    }

    post {
        success {
            echo '✅ Build succeeded!'
        }
        failure {
            echo '❌ Build failed.'
        }
    }
}
