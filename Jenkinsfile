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
        sh "${MSR_TARGET_DOCKER}/is_container.sh createPackageDockerfile -Dimage.name=is:msr -Dpackage.list=Customers -Dfile.name=CustomerMSR"
        echo 'Customers package docker file created'
      }
    }
     stage('Build Images') {
       parallel {
    stage('Customer Service') {
      steps {
        sh "${MSR_TARGET_DOCKER}/is_container.sh buildPackage -Dimage.name=is:${CustomerTag} -Dfile.name=CustomerMSR"

        echo 'Customers MSR image built successfully'
      }
    }
    stage('Customer Microgateway') {
      steps {
        sh '''#Build MicroGateway
cd /opt/softwareag_mgw105/Microgateway/
./microgateway.sh createDockerFile --docker_dir . -p 9090 -a ./tmp-docker/Customer.zip -dof ./Dockerfile -c ./tmp-docker/config.yml
docker build -t customermg:1.0 .'''
        echo 'Customers MSR image built successfully'
      }
    }
       }
    }

    stage('Register Images') {
      parallel {
      stage('Customer Service'){
      steps {
        sh "docker tag is:${CustomerTag} narraranil/is:${CustomerTag}"
        sh "docker push narraranil/is:${CustomerTag}"
        echo '${MSR_TARGET_DOCKER}/is_container.sh pushImage -Duser=${DockerRegistryUser} -Dpassword=${DockerRegistryPassword} -Dserver=${DockerRegistryUrl} -Drepository.name=${DockerRepositoryName} -Dimage.name=is:${CustomerTag}'
        echo 'Uploaded Customers MSR image built successfully'
      }
    }
     stage('Customer Microgateway'){
      steps {
        sh 'docker tag customermg:1.0 narraranil/customermg:1.0'
        sh 'docker push narraranil/customermg:1.0'
        echo 'Uploaded Customers Microgateway built successfully'
      }
    }
      }
    }
    stage('Testing'){
      parallel {

    stage ('OperationalTesting') {
	  
 			// Ant build step
 			steps{
			    echo 'Operations tested'
 				}
	
    }
    stage ('UnitTest') {
	  
 			// Ant build step
 			steps{
			
 				sh "ant -buildfile /var/lib/jenkins/workspace/AccelerateMSRCustomerImage/assets/IS/Tests/AirlineDemoTestSuiteExecutor/run-composite-runner.xml -DwebMethods.integrationServer.ssl=false -DwebMethods.home=/opt/softwareag -DwebMethods.test.setup.profile.mode=NONE -DwebMethods.integrationServer.name=localhost -DwebMethods.test.setup.location=/var/lib/jenkins/workspace/AccelerateMSRCustomerImage/assets/IS/Tests/AirlineDemoTests -DwebMethods.test.setup.external.classpath.layout=${env} -DwebMethods.integrationServer.port=5555 -DwebMethods.test.scope.packages=UnitTests -DwebMethods.integrationServer.userid=Administrator -DwebMethods.test.profile.result.location=/var/lib/jenkins/workspace/AccelerateMSRCustomerImage/assets/IS/Tests/AirlineDemoTestSuiteExecutor/test/reports/ -DwebMethods.integrationServer.password=manage composite-runner-all-tests" 
      	publishHTML([allowMissing: true, alwaysLinkToLastBuild: false, keepAll: true, reportDir: '/var/lib/jenkins/workspace/AccelerateMSRCustomerImage/assets/IS/Tests/AirlineDemoTestSuiteExecutor/test/reports/html', reportFiles: 'index.html', reportName: 'HTML Report', reportTitles: ''])
	    }
	
    }
    }
    }
	stage('Create K8s Template'){
          when {
        branch 'master'
      }
            steps {
                sh ("""
		sed -i 's/DOCKERREPO/'"$DOCKERREPO"'/g'  ${WORKSPACE}/PushCustomerImageToK8.yaml
		""")
		sh ("""
		sed -i 's/IMAGETAG/'"$IMAGETAG"'/g'  ${WORKSPACE}/PushCustomerImageToK8.yaml
		""")
		sh ("""
		sed -i 's/APPNAME/'"$APPNAME"'/g'  ${WORKSPACE}/PushCustomerImageToK8.yaml
		""")
		sh ("""
		sed -i 's/SERVICENAME/'"$SERVICENAME"'/g'  ${WORKSPACE}/PushCustomerImageToK8.yaml
		""")
		sh ("""
		sed -i 's/ENDPOINT/'"$ENDPOINT"'/g'  ${WORKSPACE}/PushCustomerImageToK8.yaml
		""")
		sh ("""
		sed -i 's/DEPLOYMENTNAME/'"$DEPLOYMENTNAME"'/g'  ${WORKSPACE}/PushCustomerImageToK8.yaml
		""")
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