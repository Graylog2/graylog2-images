if (currentBuild.buildCauses.toString().contains('BranchIndexingCause'))
{
  print "Build skipped due to trigger being Branch Indexing."
  return
}

pipeline
{
   agent none

   options
   {
      ansiColor('xterm')
      buildDiscarder logRotator(artifactDaysToKeepStr: '90', artifactNumToKeepStr: '100', daysToKeepStr: '90', numToKeepStr: '100')
      skipDefaultCheckout(true)
      timestamps()
   }

   parameters
   {
       string(name: 'Graylog_Version', defaultValue: '', description: '2.x: 2.5.0-beta.1-1 (the git tag in graylog2-images) | 3.x: 3.0.0-4.alpha.4 (the deb package version)')
       gitParameter(name: 'BRANCH',
                    description: 'The branch name that should be used for the build.',
                    type: 'PT_BRANCH',
                    defaultValue: '4.0',
                    branchFilter: 'origin/(.*)',
                    sortMode: 'DESCENDING_SMART',
                    selectedValue: 'DEFAULT')
       booleanParam(
           name: 'BUILD_AMI',
           defaultValue: false,
           description: 'Build AWS AMI image?'
       )
       booleanParam(
           name: 'BUILD_OVA',
           defaultValue: false,
           description: 'Build OVA image?'
       )
       booleanParam(
           name: 'BUILD_PRE_OVA',
           defaultValue: false,
           description: 'Build pre-OVA image?'
       )
   }

   environment
   {
     PACKAGE_VERSION="${params.Graylog_Version}"
     GRAYLOG_IMAGES_BRANCH="${params.BRANCH}"
   }

   stages
   {
     stage('Build Images')
     {
       parallel
       {
         stage('AMI')
         {
           agent
           {
             label 'linux'
           }
           when
           {
             beforeAgent true
             equals expected: true, actual: params.BUILD_AMI
             expression
             {
               //only trigger when run manually
               currentBuild.buildCauses.toString().contains('hudson.model.Cause$UserIdCause')
             }
           }
           steps
           {
              validateParameters()

              echo "Checking out graylog2-images..."
              checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: "*/${params.BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'LocalBranch', localBranch: "${params.BRANCH}"], [$class: 'WipeWorkspace']], submoduleCfg: [], userRemoteConfigs: [[url: 'git@github.com:Graylog2/graylog2-images.git']]]

              dir('packer')
              {
                sh 'packer version'

                script
                {
                  withCredentials([usernamePassword(credentialsId: 'aws-ec2-ami-creator', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')])
                  {
                    sh '''#!/bin/bash
                        set -o pipefail
                        packer build aws.json | tee packer_output
                       '''
                  }
                }
              }

              echo "Updating README.md..."
              sh '''
                  grep -A 30 "amazon-ebs: AMIs were created:" packer/packer_output | grep -v "amazon-ebs: AMIs were created:" | sed "/^$/d" > ami-ids
                  ruby scripts/update-aws-ami.rb ami-ids ${PACKAGE_VERSION%-[[:digit:]]}
                  git add -u
                  git commit -m "Updating AMI IDs in README."
                  git push origin $GRAYLOG_IMAGES_BRANCH
                 '''
           }
           post
           {
             success
             {
                cleanWs()
             }
           }
         }
         stage('OVA')
         {
             agent
             {
               label 'linux'
             }
             when
             {
               beforeAgent true
               equals expected: true, actual: params.BUILD_OVA
               expression
               {
                 //only trigger when run manually
                 currentBuild.buildCauses.toString().contains('hudson.model.Cause$UserIdCause')
               }
             }
             steps
             {
                validateParameters()

                echo "Checking out graylog2-images..."
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: "*/${params.BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'WipeWorkspace']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Graylog2/graylog2-images.git']]]

                dir('packer')
                {
                  sh '''
                  bundle install --path .bundle
                  packer build virtualbox.json
                  cd output-virtualbox-iso
                  bundle exec ../ovf2ova.rb graylog.ovf
                  mv graylog.ova graylog-${PACKAGE_VERSION}.ova
                  '''
                }

                withAWS(region:'eu-west-1', credentials:'aws-key-releases')
                {
                  s3Upload(workingDir:'packer/output-virtualbox-iso', bucket:'graylog2-releases', path:'graylog-omnibus/ova/', includePathPattern:'*.ova')
                }

             }
             post
             {
               success
               {
                  cleanWs()
               }
             }
          }
          stage('OVA Beta')
          {
              agent
              {
                label 'linux'
              }
              when
              {
                beforeAgent true
                equals expected: true, actual: params.BUILD_PRE_OVA
                expression
                {
                  //only trigger when run manually
                  currentBuild.buildCauses.toString().contains('hudson.model.Cause$UserIdCause')
                }
              }
              steps
              {
                 validateParameters()

                 echo "Checking out graylog2-images..."
                 checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: "*/${params.BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'WipeWorkspace']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Graylog2/graylog2-images.git']]]

                 dir('packer')
                 {
                   sh '''
                   bundle install --path .bundle
                   packer build virtualbox-beta.json

                   cd output-virtualbox-iso
                   if test -e "graylog-beta.ovf";then
                     bundle exec ../ovf2ova.rb graylog-beta.ovf
                     mv graylog-beta.ova graylog-pre-${PACKAGE_VERSION}.ova
                   else
                     bundle exec ../ovf2ova.rb graylog-preview.ovf
                     mv graylog-preview.ova graylog-pre-${PACKAGE_VERSION}.ova
                   fi
                   '''
                 }

                 withAWS(region:'eu-west-1', credentials:'aws-key-releases')
                 {
                   s3Upload(workingDir:'packer/output-virtualbox-iso', bucket:'graylog2-releases', path:'graylog-omnibus/ova/', includePathPattern:'*.ova')
                 }
              }
              post
              {
                success
                {
                   cleanWs()
                }
              }
           }
       }
     }
   }
}

def validateParameters()
{
  script
  {
    if (params.Graylog_Version == '')
    {
      currentBuild.result = 'ABORTED'
      error('Graylog_Version parameter is required.')
    }
  }
}
