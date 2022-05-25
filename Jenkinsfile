pipeline {
    agent any
    environment {
        NAMESPACE="rahma9079"
        IMAGE="go-violin"
        TAG_NUMBER = "1.0"
        dockerImage = ''
    }
    stages {
        stage('Building image') {
            steps {
                script {
                    dockerImage = docker.build("${NAMESPACE}/${IMAGE}")
                }
             }
        }
        stage('Pushing Image to dockerhub') {
            steps{
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_account' ) {
                        dockerImage.push("${TAG_NUMBER}")
                    }
                }
            }
        }
  }
  post {
      always {
          sh 'docker logout'
      }
      success {
          echo "Image build and published to ${NAMESPACE}/${IMAGE}:${TAG_NUMBER} successfully"
      }
      failure {
          echo "Process failed"
      }
  }
}