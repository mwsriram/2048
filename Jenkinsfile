pipeline {
    agent any

    // Trigger build automatically when code is pushed to GitHub
    triggers {
        githubPush()
    }

    environment {
        GIT_CREDENTIALS = 'github-ssh-key'  // Jenkins SSH key ID
        REPO_URL = 'git@github.com:yourusername/your-2048-repo.git'
        BRANCH = 'master
        
        '
    }

    stages {
        stage('Checkout') {
            steps {
                echo "Cloning 2048 game repo..."
                git branch: env.BRANCH,
                    url: env.REPO_URL,
                    credentialsId: env.GIT_CREDENTIALS
            }
        }

        stage('Build / Setup') {
            steps {
                echo 'Setting up the 2048 game...'

                // Example commands depending on your project type:
                sh '''
                # Python 2048 game
                if [ -f requirements.txt ]; then
                    echo "Installing Python dependencies..."
                    pip install -r requirements.txt
                fi

                # Node.js 2048 game
                if [ -f package.json ]; then
                    echo "Installing Node.js dependencies..."
                    npm install
                fi

                # Java 2048 game
                if [ -f pom.xml ]; then
                    echo "Building Java project..."
                    mvn clean package
                fi
                '''
            }
        }

        stage('Run / Test') {
            steps {
                echo 'Running the 2048 game...'
                sh '''
                # Example: run Python 2048
                if [ -f main.py ]; then
                    echo "Running Python 2048 game..."
                    python main.py &
                fi

                # Example: run Node.js 2048 (for web version)
                if [ -f package.json ]; then
                    echo "Starting Node.js 2048 server..."
                    npm start &
                fi

                # Java example
                if [ -f target/2048.jar ]; then
                    echo "Running Java 2048..."
                    java -jar target/2048.jar &
                fi
                '''
            }
        }
    }

    post {
        success {
            echo '✅ 2048 game build and run succeeded!'
        }
        failure {
            echo '❌ Build failed. Check console output.'
        }
    }
}
