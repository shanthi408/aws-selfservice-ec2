pipeline {
    agent
    {
        label 'platform'
    }

    environment {
      config_path = ''
    }

    parameters {
        booleanParam(defaultValue: false, description: 'Set Value to True to Initiate Destroy Stage', name: 'destroy')
    }

    options {
        buildDiscarder(logRotator(numToKeepStr: '30'))
        disableConcurrentBuilds()
    }

    stages {

        stage('TerraRising') {

            steps {


                 sh '''#!/bin/bash -l

                  echo "Start time: $(date)"
                  echo "AWS Account Information:"
                  echo
                  echo -e "Account:           \t\t\t $aws_account"
                  echo -e "Region:            \t\t\t $aws_region"
                  echo -e "Environment:       \t\t\t $Environment"

                  ENV=$environment REGION=$region make prep

                   set +x


                   cd "${tf_home}"

                   echo "End time: $(date)"
                   echo "=====End of Terraform Rising======="

                 '''
            }
        }


        stage('TerraPlanning') {

            when {
                 anyOf {
                expression { !params.destroy }
                }
            }

              steps {

                  sh '''#!/bin/bash -l

                    echo "Start time: $(date)"

                    echo "End time: $(date)"
                    echo "=======End of Terraform Planning======="

                    ENV=$environment REGION=$region make plan

                  '''

            }
        }



        stage("ValidateBeforeDeploy") {

            when {
                 allOf {
                    expression { !params.destroy }
                }
            }

            steps {

                echo "Terraform DEPLOY/APPLY of  ${account_moniker} in AWS: ${aws_accountprefix} / ${aws_account} / ${aws_region}"
                input 'Are you sure you want to Deploy/Apply? Review the output of the previous step (plan) before proceeding!'
            }
        }



        stage('TerraApplying') {

            steps {


                sh '''#!/bin/bash -l

                  echo "Start time: $(date)"

                  echo "End time: $(date)"
                  echo "=======End of Terraform Apply========"

                  ENV=$environment REGION=$region make plan

                  '''
            }
        }


        stage("ValidateBeforeDestroy") {

            steps {
                echo "Terraform DESTROY/DELETE ${account_moniker} in AWS: ${aws_accountprefix} / ${aws_account} / ${aws_region}"
                input 'Are you sure you want to DESTROY/DELETE? Carefully review the output of the previous DESTROY (plan) before proceeding!'
            }
        }



        stage('TerraDestroy') {

            when {
                 allOf {
                    expression { params.destroy }
                }
            }

            steps {

                echo "=========== Terraform DESTROY ${account_moniker} in AWS: ${aws_accountprefix} / ${aws_account} / ${aws_region}"

                sh '''#!/bin/bash -l

                  echo "Start time: $(date)"

                  echo "End time: $(date)"
                  echo "=======End of Terraform Destroy======="

                  ENV=$environment REGION=$region make plan

                  '''

            }
        }

    }
}
