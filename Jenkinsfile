pipeline {
  agent any
  stages {
    stage('Initialize') {
      steps {
        sh 'chmod -R 777 ${WORKSPACE}'
      }
    }

    stage('Copy Packages from Git') {
      steps {
        sh '${WORKSPACE}/CopyPackageToVM.sh'
      }
    }

    stage('Create Customer docker files') {
      steps {
        sh "${MSR_TARGET_DOCKER}/is_container.sh createPackageDockerfile -Dimage.name=store/softwareag/webmethods-microservicesruntime:10.5.0.3-alpine -Dpackage.list=Customers -Dfile.name=CustomerMSR"
        echo 'Customers package docker file created'
      }
    }
    stage('Customer Service') {
      steps {
        sh "${MSR_TARGET_DOCKER}/is_container.sh buildPackage -Dimage.name=is:${CustomerTag} -Dfile.name=CustomerMSR"

        echo 'Customers MSR image built successfully'
      }     
    }
    stage('Register Customer Images') {
      steps {
        sh "docker tag is:${CustomerTag} narraranil/is:${CustomerTag}"
        sh "docker push narraranil/is:${CustomerTag}"
        echo '${MSR_TARGET_DOCKER}/is_container.sh pushImage -Duser=${DockerRegistryUser} -Dpassword=${DockerRegistryPassword} -Dserver=${DockerRegistryUrl} -Drepository.name=${DockerRepositoryName} -Dimage.name=is:${CustomerTag}'
        echo 'Uploaded Customers MSR image built successfully'
      }
    }
	
	stage('Push Customer image To K8'){
    when {
        branch 'master'
      }
		steps{
		sh '${WORKSPACE}/DeployCustomerImageToK8.sh'
	    }
	}

stage('Clean') {
      steps {
        sh '''#Tidy up after build

#Stop containers
#docker stop productmg
#docker stop productservicems

#Prune
docker image prune -f
docker volume prune -f

'''
      }
    }
  }
}