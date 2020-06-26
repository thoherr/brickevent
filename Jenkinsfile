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

    agent any

    environment {
        DOCKER_REGISTRY_URL = credentials("DOCKER_REGISTRY_URL")
    }

    triggers {
        cron('H 3 * * 2')
    }

    stages {
        stage("Tag with build number") {
            steps {
                sh """
                    echo ${BUILD_NUMBER} >${WORKSPACE}/BUILDNUMBER
                    echo ${GIT_COMMIT} >${WORKSPACE}/REVISION
                """
            }
        }

        stage("Build docker container") {
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
                    rake db:migrate
                    rake test
                """
            }
        }

        stage("Push container") {
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

