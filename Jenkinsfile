pipeline {
  agent any
  options { skipDefaultCheckout(true) }        // we'll do our own checkout
  triggers { pollSCM('* * * * *
') }          // poll GitHub every ~5 minutes

  stages {
    stage('Checkout (master only)') {
      when { branch 'master' }
      steps {
        git url: 'https://github.com/mwsriram/2048.git', branch: 'master'
      }
    }

    stage('Build + Run (master only)') {
      when { branch 'master' }
      steps {
        sh '''
          echo "Building Docker image..."
          docker build -t 2048-game .

          echo "Stopping old container if exists..."
          docker rm -f 2048-container || true

          echo "Running new container..."
          docker run -d --name 2048-container -p 80:80 2048-game
        '''
      }
    }
  }
}
