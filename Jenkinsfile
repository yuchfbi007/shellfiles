pipeline {
  agent any
  stages {
    stage('hello') {
      steps {
        echo 'hello'
      }
    }
    stage('build') {
      steps {
        build job: 'DevOps/build'
      }
    }
    stage('finish') {
      steps {
        echo 'finish'
      }
    }
  }
}
