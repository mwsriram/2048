pipeline {
  agent any
  triggers { githubPush() }   // run on GitHub push

  environment {
    EC2_HOST = 'ubuntu@54.89.204.116'   // change me
    APP_NAME = 'game2048'
    CONTAINER = 'game2048-web'
    PORT = '80'
  }

  stages {
    stage('Checkout') {
      steps {
        deleteDir()
        checkout scm
        sh 'git rev-parse --short HEAD > version.txt'
      }
    }

    stage('Deploy (Docker on EC2)') {
      steps {
        sshagent(credentials: ['ec2-ssh-key']) {
          sh """
            set -e
            # 1) Send source to EC2 (only needed files for static site)
            rsync -az --delete . ${EC2_HOST}:/home/ubuntu/${APP_NAME}/

            # 2) Build the image ON EC2 (no registry required)
            ssh -o StrictHostKeyChecking=no ${EC2_HOST} '
              set -e
              cd /home/ubuntu/${APP_NAME}
              # If you use npm to build, do it here:
              if [ -f package.json ]; then
                npm ci || npm install
                npm run build || npm run build:prod || true
              fi

              # Build nginx-based static image
              cat > Dockerfile <<EOF
              FROM nginx:alpine
              WORKDIR /usr/share/nginx/html
              COPY dist/ ./ || true
              COPY build/ ./ || true
              COPY public/ ./ || true
              COPY index.html ./ || true
              COPY version.txt ./version.txt
              EOF

              docker build -t ${APP_NAME}:latest .

              # 3) Replace running container on port 80
              docker rm -f ${CONTAINER} || true
              docker run -d --name ${CONTAINER} -p ${PORT}:80 ${APP_NAME}:latest
            '
          """
        }
      }
    }
  }
}
