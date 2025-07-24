pipeline {
    agent none

    environment {
        GITHUB_REPO = 'ukim-ambon/gcp-cdsc-multipipelines'
        DOCKER_IMAGE = 'europe-west2-docker.pkg.dev/ndr-discovery-387213/cdsc-artreg/prod-img:v2'
        DOCKER_REGISTRY = 'https://europe-west2-docker.pkg.dev'
        DOCKER_CREDENTIAL_ID = 'gcp-artifact-registry-creds'
    }

    stages {
        stage('Run in Docker Image') {
            agent any

            steps {
                script {
                    docker.withRegistry(env.DOCKER_REGISTRY, env.DOCKER_CREDENTIAL_ID) {
                        docker.image(env.DOCKER_IMAGE).inside('-u root') {

                            // Run everything inside the custom image
                            checkout scm

                            sh 'npm install'
                            sh 'npm run lint'

                            // Optional: confirm R + testthat is working
                            sh 'Rscript -e "library(testthat); print(\'testthat loaded OK\')"'

                            // Run your test script
                            sh 'Rscript campylobacter_analysis/tests/uTest_start.R'
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            script {
                updateGitHubStatus('success', 'Build succeeded')
            }
        }
        failure {
            script {
                updateGitHubStatus('failure', 'Build failed')
            }
        }
    }
}

def updateGitHubStatus(String state, String description) {
    def commitSha = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
    def buildUrl = env.BUILD_URL ?: 'https://8080-cs-90bc33d3-2207-4028-9b8e-369b8626fcbf.cs-europe-west1-iuzs.cloudshell.dev/job/' + env.JOB_NAME + '/' + env.BUILD_NUMBER + '/'

    withCredentials([usernamePassword(credentialsId: 'jenkins-cdsc-token', usernameVariable: 'GITHUB_USER', passwordVariable: 'GITHUB_TOKEN')]) {
        sh """
            curl -s -u "\$GITHUB_USER:\$GITHUB_TOKEN" -X POST -d @- https://api.github.com/repos/${env.GITHUB_REPO}/statuses/${commitSha} <<EOF
            {
                "state": "${state}",
                "context": "continuous-integration/jenkins/pr-merge",
                "description": "${description}",
                "target_url": "${buildUrl}"
            }
EOF
        """
    }
}
