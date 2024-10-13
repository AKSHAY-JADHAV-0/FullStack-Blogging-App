pipeline {
    agent any
    tool{
        jdk17
        maven3
    }
    
    Environment{
        
        
    }

    stages {
        stage('git_checkout') {
            steps {
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    extensions: [], 
                    userRemoteConfigs: [[
                        url: 'https://github.com/AKSHAY-JADHAV-0/FullStack-Blogging-App.git', 
                        credentialsId: 'git-cred'
                    ]]
                ])
            }
        }
        
        stage('Maven Build') {
            steps {
                script {
                    sh 'mvn clean package'
                }
            }
        }

        stage('Maven Compile') {
            steps {
                script {
                    sh 'mvn compile'
                }
            }
        }

        stage('Maven Test') {
            steps {
                script {
                    sh 'mvn test'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                        // Run SonarQube analysis
                        sh """
                            mvn clean verify sonar:sonar \
                            -Dsonar.projectKey=fullstack_webapp \
                            -Dsonar.host.url=http://3.110.147.61:9000 \
                            -Dsonar.login=${SONAR_TOKEN}
                        """
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        
        stage('Publish To Nexus') {
            steps {
            withMaven(globalMavenSettingsConfig: 'maven-setting', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                sh 'mvn deploy'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "dokcer login -u akshay196 -p docker-cred"
                    sh "docker build -t ${DOCKER_IMAGE} ."
                    sh "trivy image --format table -o trivy-image-report.html ${DOCKER_IMAGE}"
                    sh "docker push ${NEXUS_URL}/${DOCKER_IMAGE}"
                }
            }
        }
        
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
    }
}
