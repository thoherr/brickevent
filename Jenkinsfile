// Jenkinsfile for brickevent

// compute revision based on build-number and branch
if(env.JOB_BASE_NAME == "master") {
    revision="b-${env.BUILD_NUMBER}"
} else if (env.JOB_BASE_NAME.startsWith("PR-")) {
    revision="${env.JOB_BASE_NAME}-dev"
} else {
    revision="${env.JOB_BASE_NAME}-b-${env.BUILD_NUMBER}"
}

dockerImageName = "brickevent:${revision}"
dockerImage = null

pipeline {

    agent none

    environment {
        DOCKER_REGISTRY_URL = credentials("DOCKER_REGISTRY_URL")
    }

    stages {
        stage("Tag with build number") {
            agent { label 'tt-ubuntu18-jenkins-builder-java11-ruby25' }
            steps {
                sh """
                    echo ${BUILD_NUMBER} >${WORKSPACE}/BUILDNUMBER
                    echo ${GIT_COMMIT} >${WORKSPACE}/REVISION
                """
            }
        }

        stage("Build docker container") {
            agent { label 'tt-ubuntu18-jenkins-builder-java11-ruby25' }
            steps {
                script {
                    dockerImage = docker.build(dockerImageName)
                }
            }
        }

        stage("Test container") {
            agent {
                docker {
                    image dockerImageName
                    args "--entrypoint ''"
                }
            }
            steps {
                sh """
                    echo "############################################################"
                    id
                    pwd
                    ls -la
                    ls -ls /brickevent
                    env
                    echo "############################################################"
                    rm -r /brickevent/log
                    rm -f log/*.log
                    ln -s \$(pwd)/log /brickevent/log
                    mkdir -p tmp/screenshots
                    rm -f tmp/screenshots/*
                    ln -s \$(pwd)/tmp/screenshots /brickevent/tmp/screenshots
                """
                sh """
                    cd /brickevent
                    bundle config
                    bundle list
                    bundle exec rails db:migrate RAILS_ENV=test
                """
                sh """
                    cd /brickevent
                    bundle exec rails test
                """
                sh """
                    cd /brickevent
                    bundle exec rails test:system
                """
            }
            post {
                always {
                    archiveArtifacts artifacts: 'log/*.log', fingerprint: true, allowEmptyArchive: true
                    dir('tmp/') {
                        archiveArtifacts artifacts: 'screenshots/', fingerprint: true, allowEmptyArchive: true
                    }
                }
            }
        }

        stage("Push container") {
            agent { label 'tt-ubuntu18-jenkins-builder-java11-ruby25' }
            steps {
                script {
                    docker.withRegistry("${DOCKER_REGISTRY_URL}") {
                        dockerImage.push()
                    }
                }
            }
        }
    }
}

