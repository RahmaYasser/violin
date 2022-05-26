pipeline {
    agent any
    environment {
        NAMESPACE="rahma9079"
        IMAGE="go-violin"
        TAG_NUMBER="1.1"
        dockerImage=''
        CREDENTIALS_ID='kube_config'
        CONTEXT_NAME='minikube'
        CLUSTER_NAME='minikube'
        SERVER_URL='https://192.168.49.2:8443'
        SLACK_CHANNEL='devops-team'
    }
    stages {
        stage('Building image') {
            steps {
                script {
                    try {
                        dockerImage = docker.build("${NAMESPACE}/${IMAGE}")
                    }catch (err) {
                        withCredentials([string(credentialsId: 'slacktoken', variable: 'TOKEN')]) {
                            echo "Pipeline failed to build docker image."
                            sh 'curl -d "Pipeline failed to build docker image." -d "channel=${SLACK_CHANNEL}" -H "Authorization: Bearer ${TOKEN}" -X POST https://slack.com/api/chat.postMessage'
                        }
                    }
                }
             }
        }
        
        stage('Pushing Image to dockerhub') {
            steps{
                script {
                    try {
                        docker.withRegistry('https://index.docker.io/v1/', 'dockerhub_account' ) {
                            dockerImage.push("${TAG_NUMBER}")
                        }
                    }catch (err) {
                        withCredentials([string(credentialsId: 'slacktoken', variable: 'TOKEN')]) {
                            echo "Pipeline failed to push docker image."
                            sh 'curl -d "Pipeline failed to push docker image." -d "channel=${SLACK_CHANNEL}" -H "Authorization: Bearer ${TOKEN}" -X POST https://slack.com/api/chat.postMessage'
                        }
                    }
                    
                }
            }
        }
        
        stage('Deploying to K8S') {
            steps {
                script {
                    try {
                    withKubeConfig([
                    credentialsId: "${CREDENTIALS_ID}",
                    contextName: "${CONTEXT_NAME}",
                    clusterName: "${CLUSTER_NAME}",
                    namespace: 'default',
                    serverUrl: "${SERVER_URL}"
                    ]) {
                        sh 'kubectl apply -f ${WORKSPACE}/config-map.yaml'
                        sh 'kubectl apply -f ${WORKSPACE}/deployment.yaml'
                        sh 'kubectl apply -f ${WORKSPACE}/service.yaml'
                        sh 'kubectl apply -f ${WORKSPACE}/ingress.yaml'
                    }
                    }catch (err) {
                        withCredentials([string(credentialsId: 'slacktoken', variable: 'TOKEN')]) {
                        echo "Pipeline failed to deploy app to k8s"
                        sh 'curl -d "Pipeline failed to deploy app to k8s" -d "channel=${SLACK_CHANNEL}" -H "Authorization: Bearer ${TOKEN}" -X POST https://slack.com/api/chat.postMessage'
                        }
                    }
                }
                
            }
        }
  }

  post {
      always {
            echo "Pipeline complited successfully"
            sh 'docker logout'
            sh 'curl -d "Pipeline complited successfully" -d "channel=${SLACK_CHANNEL}" -H "Authorization: Bearer ${TOKEN}" -X POST https://slack.com/api/chat.postMessage'

      }
  }
}
