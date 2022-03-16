pipeline{
    agent{
        docker{
            //image 'hashicorp/terraform:latest'
            image 'zenika/terraform-aws-cli:latest'
            args  '--entrypoint="" -u root -v /opt/jenkins/.aws:/root/.aws'
        }
    }   

    environment{
        REGION = "ap-southeast-2"
        //SPACE = "uat"        
    }

    options{
				buildDiscarder(logRotator(numToKeepStr:'20', artifactNumToKeepStr:'20'))
    }
    
    stages{
        stage("init"){
            when {
                expression {init_or_not=="init_from_empty_state"}
            }

            steps{
                echo "starting tf init"
                withAWS(credentials: '4b4c942f-2dd7-4c3f-a4ac-0250a775a3df', region:"${REGION}") {
                    script{     
                        try{
                            sh "terraform init"
                            } catch(err){
                                //message: got an error  with new backend config
                                sh 'rm -rf .terraform'                                
                                sh "terraform init"
                            }
                        }    
                    }
                }    
            }

        stage("validate"){
            when{
                expression {action_to_take=="plan_and_apply"}
            }
            steps{
                echo "starting to validate"
                sh 'terraform validate'                
            }
        }

        stage('plan'){
            when{
                expression {action_to_take=="plan_and_apply"}
            }
            steps{
                echo " start planning "
                withAWS(credentials: '4b4c942f-2dd7-4c3f-a4ac-0250a775a3df', region:"${REGION}") {  //cicd
                    //withAWS(credentials: '76a8acba-e3c4-46a5-b1c8-51766d24e7a2', region:"${REGION}") {  //local
                    // tfp resources
                    script{
                        try{
                        sh "terraform workspace new ${WORKSPACE}"
                        } catch(err){
                            //message: got an error                                
                            sh "terraform workspace select ${WORKSPACE}"
                        }
                        sh 'aws s3 cp s3://${AW_TFVARS_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfvars .'
                        sh 'terraform plan -out terraform.tfplan; echo \$? >status'
                        stash name: "terraform-plan", includes: "terraform.tfplan"                                     
                        // sh 'terraform graph w -json terraform.tfplan >plan.json'
                        // sh 'terraform-visual --plan plan.json'
                    }
                    sh 'pwd'
                    sh 'ls -al' 
                }
            }           
        }

        stage('apply'){
            when{
                expression {action_to_take=="plan_and_apply"}
            }
            steps{
                echo " start tfa with auto approve "
                withAWS(credentials: '4b4c942f-2dd7-4c3f-a4ac-0250a775a3df', region:"${REGION}") {
                    // create tf resources
                    script{
                            def apply = false
                            try {
                                input message: "want to apply?", ok:"ready to apply"
                                apply = true
                            }
                            catch(err){
                                apply = false
                                currentBuild.result = 'UNSTABLE'
                            }
                            if(apply){
                                unstash "terraform-plan"
                                sh 'terraform apply terraform.tfplan'
                            }
                    }
                    sh 'pwd'
                    sh 'ls -al'     
                    sh 'aws s3 cp terraform.tfplan s3://${AW_TFVARS_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfplan'               
                    //sh 'aws s3 cp terraform.tfstate.d/${WORKSPACE}/terraform.tfstate s3://${STATEFILE_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfstate'
                    //sh 'aws s3 cp terraform.tfstate.d/${WORKSPACE}/terraform.tfstate.backup s3://${STATEFILE_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfstate.backup'                
                }
            }            
        }

        stage('destroy'){
            when{
                expression {action_to_take=="destroy_resources"}
            }
            steps{
                echo "starting to destroy auto"
                withAWS(credentials: '4b4c942f-2dd7-4c3f-a4ac-0250a775a3df', region:"${REGION}"){
                    script{
                        echo "start to destroy"
                        def destroy = false
                        try{
                            input message: "want to destroy?", ok:"ready to destroy"
                            destroy = true
                        }
                        catch(err){
                            destroy = false
                            currentBuild.result = 'UNSTABLE'
                        }
                        if (destroy){
                            echo "start to destroy"
                            //sh 'aws s3 cp s3://${STATEFILE_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfstate ./terraform.tfstate.d/${WORKSPACE}/terraform.tfstate'
                            //sh 'aws s3 cp s3://${STATEFILE_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfstate.backup .terraform.tfstate.d/${WORKSPACE}/terraform.tfstate.backup'
                            sh 'terraform destroy --auto-approve'
                            //sh 'aws s3 cp terraform.tfstate.d/${WORKSPACE}/terraform.tfstate s3://${STATEFILE_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfstate'
                            //sh 'aws s3 cp terraform.tfstate.d/${WORKSPACE}/terraform.tfstate.backup s3://${STATEFILE_BUCKET}/${JOB_NAME}/${WORKSPACE}/terraform.tfstate.backup'
                        } 
                            echo "resources destroyed"
                    }                        
                }        
            }
        }         
    }   

    post {
		failure {
			echo "failed "
			emailext attachLog: true, 
			body: '${DEFAULT_CONTENT}',
			subject: '${PROJECT_NAME} - Build # ${BUILD_NUMBER} - ${BUILD_STATUS}!',
			replyTo: 'johnwu94@gmail.com',
			to: 'johnwu94@gmail.com' //'${DEV}, cc:${CC_RECIPIENTS}'		
		}
		
		success {
			echo "well done" 
			emailext attachLog: false, 
			body: '${DEFAULT_CONTENT}',                         
			subject: '${PROJECT_NAME} - Build # ${BUILD_NUMBER} - ${BUILD_STATUS}!',
			//replyTo: //'${DEVOPS_TEAM}',
			to: 'johnwu94@gmail.com'//'${DEV}, cc:${CC_RECIPIENTS}'         
		}
	}
}