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
        build(job: 'build', wait: true)
      }
    }
  }
}