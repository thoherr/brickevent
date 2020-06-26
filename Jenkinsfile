// Jenkinsfile for brickevent

// compute revision based on build-number and branch
if(env.JOB_BASE_NAME == "master") {
    revision="b-${env.BUILD_NUMBER}"
} else if (env.JOB_BASE_NAME.startsWith("PR-")) {
    revision="${env.JOB_BASE_NAME}-dev"
} else {
    revision="${env.JOB_BASE_NAME}-b-${env.BUILD_NUMBER}"
}

dockerImage = null

pipeline {

    agent any

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
                    dockerImage = docker.build("brickevent:${revision}")
                }
            }
        }

        // /TODO: Test container

        // TODO: Push container to registry
    }
}

