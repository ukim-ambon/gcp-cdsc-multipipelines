pipeline {
    agent any

    environment {
        GITHUB_REPO = 'ukim-ambon/gcp-cdsc-multipipelines'
		R_LIBS_USER = "${env.WORKSPACE}/R_libs"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }
		
		stage('Install R Packages') {
            steps {
                sh '''
                    mkdir -p "$R_LIBS_USER"
                    Rscript -e "install.packages('testthat', lib=Sys.getenv('R_LIBS_USER'), repos='https://cloud.r-project.org')"
                '''
            }
        }
		
        stage('Run R Tests') {
            steps {
                sh '''					
					export R_LIBS_USER="$WORKSPACE/R_libs"
					Rscript campylobacter_analysis/tests/uTest_start.R
				'''
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
