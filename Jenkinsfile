pipeline {
  agent any
  options {
    timestamps()
    skipDefaultCheckout(true)
  }

  parameters {
    string(name: 'AWS_ACCOUNT_ID', defaultValue: '123456789012', description: 'Your AWS Account ID')
    string(name: 'AWS_REGION',     defaultValue: 'us-east-1',    description: 'AWS Region of your ECR/ECS')
    string(name: 'IMAGE_REPO',     defaultValue: '2048-game',    description: 'ECR repository name')
    booleanParam(name: 'DEPLOY',   defaultValue: false,          description: 'If true, update ECS service')
    string(name: 'ECS_CLUSTER',    defaultValue: '',             description: '(When DEPLOY=true) ECS cluster name')
    string(name: 'ECS_SERVICE',    defaultValue: '',             description: '(When DEPLOY=true) ECS service name')
  }

  environment {
    AWS_DEFAULT_REGION = "${params.AWS_REGION}"
    IMAGE_TAG = "${env.GIT_COMMIT ? env.GIT_COMMIT.take(7) : env.BUILD_NUMBER}"
    ECR_URI   = "${params.AWS_ACCOUNT_ID}.dkr.ecr.${params.AWS_REGION}.amazonaws.com/${params.IMAGE_REPO}"
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/mwsriram/2048.git', branch: 'main'
      }
    }

    stage('Login to AWS & ECR') {
      steps {
        withAWS(credentials: 'aws-creds', region: "${params.AWS_REGION}") {
          sh '''
            aws --version
            # Create ECR repo if it does not exist (idempotent)
            aws ecr describe-repositories --repository-names "${IMAGE_REPO}" >/dev/null 2>&1 || \
              aws ecr create-repository --repository-name "${IMAGE_REPO}" >/dev/null

            aws ecr get-login-password --region "${AWS_DEFAULT_REGION}" | \
              docker login --username AWS --password-stdin "${ECR_URI%/*}"
          '''
        }
      }
    }

    stage('Build Image') {
      steps {
        sh '''
          docker build -t "${IMAGE_REPO}:${IMAGE_TAG}" .
          docker tag "${IMAGE_REPO}:${IMAGE_TAG}" "${ECR_URI}:${IMAGE_TAG}"
          # Optional: also tag "latest"
          docker tag "${IMAGE_REPO}:${IMAGE_TAG}" "${ECR_URI}:latest"
        '''
      }
    }

    stage('Push to ECR') {
      steps {
        sh '''
          docker push "${ECR_URI}:${IMAGE_TAG}"
          docker push "${ECR_URI}:latest"
        '''
      }
    }

    stage('Deploy to ECS') {
      when {
        expression { return params.DEPLOY && params.ECS_CLUSTER?.trim() && params.ECS_SERVICE?.trim() }
      }
      steps {
        withAWS(credentials: 'aws-creds', region: "${params.AWS_REGION}") {
          sh '''
            # Update the ECS service to use the new image by forcing a new deployment.
            aws ecs update-service \
              --cluster "${ECS_CLUSTER}" \
              --service "${ECS_SERVICE}" \
              --force-new-deployment >/dev/null

            echo "Triggered ECS deployment for ${ECS_CLUSTER}/${ECS_SERVICE}"
          '''
        }
      }
    }
  }

  post {
    always {
      sh '''
        docker image prune -f >/dev/null 2>&1 || true
      '''
    }
  }
}
