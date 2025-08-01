pipeline {
    agent { label 'BUILD_STATION' }

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-key')
        TF_TOKEN_app_terraform_io = credentials('terraform-cloud-token')
        TF_LOG = "${env.TF_LOG_LEVEL}"
        TF_BACKEND_FILES_DIR = "backend-configs"
    }

    parameters {
        choice(name: 'BACKEND_TYPE', choices: ['remote', 's3', 'gcs', 'azurerm'], description: 'Choose the backend type for Terraform initialization')

        choice(name: 'HCP_EXEC_MODE', choices: ['local', 'remote'], description: 'Choose the Terraform Cloud workspace execution mode')

        string(name: 'BACKEND_CONFIG', defaultValue: 'remote-amd.hcl', description: 'Specify backend config file for Terraform initialization (e.g., remote-staging.hcl or gcs-staging.hcl)')
        string(name: 'TF_VAR_FILE', defaultValue: 'amd.tfvars', description: 'Specify the Terraform variable file (e.g., generic.tfvars).')
        booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy resources instead of applying.')
    }

    stages {
        stage('Check Mandatory Parameters') {
            steps {
                script {
                    if (!(params.BACKEND_TYPE == 'remote' && params.HCP_EXEC_MODE == 'remote')) {
                        if (!params.BACKEND_CONFIG || !params.TF_VAR_FILE) {
                            error "Both BACKEND_CONFIG and TF_VAR_FILE must be provided to proceed."
                        }
                    }

                    if (params.BACKEND_TYPE != 'remote' && params.HCP_EXEC_MODE == 'remote') {
                        error "This backend type only supports 'local' execution mode. Aborting pipeline."
                    }

                    if (params.BACKEND_TYPE == 'remote') {
                        if (params.HCP_EXEC_MODE == 'remote') {
                            def autoTfvarsFiles = sh(script: 'ls *.auto.tfvars', returnStatus: true)
                            if (autoTfvarsFiles != 0) {  // If no *.auto.tfvars files exist
                                error "Terraform 'remote' backend and 'remote' execution mode require '*.auto.tfvars' files. Aborting pipeline."
                            }

                            if (params.TF_VAR_FILE) {
                                error "Terraform 'remote' backend and 'remote' execution mode do not support providing variables via -var-file. Aborting pipeline."
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    dir("${WORKSPACE}") {
                        if (params.BACKEND_CONFIG) {
                            sh "terraform init -backend-config='${TF_BACKEND_FILES_DIR}/${params.BACKEND_CONFIG}'"
                        } else {
                            sh 'terraform init'
                        }
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    dir("${WORKSPACE}") {
                        def tfVarFile = (params.BACKEND_TYPE != 'remote' || params.HCP_EXEC_MODE != 'remote') ? "-var-file=${params.TF_VAR_FILE}" : ""
                        sh "terraform plan ${tfVarFile}"
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return !params.DESTROY_TERRAFORM }
            }
            steps {
                script {
                    dir("${WORKSPACE}") {
                        def tfVarFile = (params.BACKEND_TYPE != 'remote' || params.HCP_EXEC_MODE != 'remote') ? "-var-file=${params.TF_VAR_FILE}" : ""
                        echo "Applying Terraform plan..."
                        sh "terraform apply -auto-approve ${tfVarFile}"
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression { return params.DESTROY_TERRAFORM }
            }
            steps {
                script {
                    dir("${WORKSPACE}") {
                        def tfVarFile = (params.BACKEND_TYPE != 'remote' || params.HCP_EXEC_MODE != 'remote') ? "-var-file=${params.TF_VAR_FILE}" : ""
                        echo "Destroying Terraform resources..."
                        sh "terraform destroy -auto-approve ${tfVarFile}"
                    }
                }
            }
        }
    }

    post {
        always {
            slackSend color: "#FFFF00", message: """Terraform run started: ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)
            
            Backend Type: ${params.BACKEND_TYPE}
            Execution Mode: ${params.HCP_EXEC_MODE}
            Backend Config: ${params.BACKEND_CONFIG}
            Variables File: ${params.TF_VAR_FILE}
            Destroy Resources: ${params.DESTROY_TERRAFORM}
            Terraform Log Level: ${env.TF_LOG}
            """
        }
        success {
            slackSend color: "#00FF00", message: "Terraform apply/destroy completed successfully - Job: ${env.JOB_NAME} - Build: ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
        failure {
            slackSend failOnError: true, color: "#FF0000", message: "Terraform apply/destroy failed - Job: ${env.JOB_NAME} - Build: ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)"
        }
    }

}