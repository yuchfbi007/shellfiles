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
    stage('完成') {
      steps {
        echo 'finish'
      }
    }
  }
}
