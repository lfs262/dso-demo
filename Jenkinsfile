pipeline {
  agent {
    kubernetes {
      yamlFile 'build-agent.yaml'
      defaultContainer 'maven'
      idleMinutes 1
    }
  }
  stages {
    stage('Build') {
      parallel {
        stage('Compile') {
          steps {
            container('maven') {
              sh 'mvn compile'
            }
          }
        }
      }
    }
    stage('Static Analysis') {
      parallel {
        stage('Unit Tests') {
          steps {
            container('maven') {
              sh 'mvn test'
            }
          }
        }
        stage('SCA') {
          steps {
            container('maven') {
              catchError(buildResult: 'SUCCESS', stageResult:'FAILURE') {
                sh 'mvn org.owasp:dependency-check-maven:check'
             }
           }
         }
          post {
            always {
              archiveArtifacts allowEmptyArchive: true,artifacts: 'target/dependency-check-report.html', fingerprint:true, onlyIfSuccessful: true
              // dependencyCheckPublisher pattern: 'report.xml'
            }
        }
    }
    }
    }
    stage('Package') {
      parallel {
        stage('Create Jarfile') {
          steps {
            container('maven') {
              sh 'mvn package -DskipTests'
            }
          }
        }
        stage('Build with Kaniko') {
          steps {
            container('kaniko') {
           sh '/kaniko/executor -f `pwd`/Dockerfile -c `pwd` --insecure --skip-tls-verify --cache=true --destination=docker.io/vinycoolguy/dsodemo'
            }
      }
    }
      }
    }

    stage('Deploy to Dev') {
      steps {
        // TODO
        sh "echo done"
      }
    }
  }
}
