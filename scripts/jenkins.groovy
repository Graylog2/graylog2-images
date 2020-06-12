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
      buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '100', daysToKeepStr: '30', numToKeepStr: '100')
      skipDefaultCheckout(true)
      timestamps()
   }

   parameters
   {
       string(name: 'Graylog_Version', defaultValue: '', description: '2.x: 2.5.0-beta.1-1 (the git tag in graylog2-images) | 3.x: 3.0.0-4.alpha.4 (the deb package version)')
       gitParameter branchFilter: 'origin/(.*)', defaultValue: '', name: 'BRANCH', type: 'PT_BRANCH', sortMode: 'DESCENDING_SMART', description: 'The branch name that should be used for the build.'
       extendedChoice(name: 'Image_Type',
                      type: 'PT_CHECKBOX',
                      multiSelectDelimiter: " ", // this only defines delimiter used in the output string value, not used for parsing value input, which must be comma-separated!
                      value: """'Build AMI', 'Build OVA', 'Build Beta OVA'""",
                      defaultValue: '',
                      description: 'What type of image do you want to build?'
     )
   }

   environment
   {
     PACKAGE_VERSION="${params.Graylog_Version}"
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
             expression
             {
               params.Image_Type.contains("Build AMI")
             }
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
                sh 'packer version'

                script
                {
                  withCredentials([usernamePassword(credentialsId: 'aws-ec2-ami-creator', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')])
                  {
                    sh 'packer build aws.json'
                  }
                }
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
         stage('OVA')
         {
             agent
             {
               label 'linux'
             }
             when
             {
               beforeAgent true
               expression
               {
                 params.Image_Type.contains("Build OVA")
               }
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
                checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: "*/${params.BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'WipeWorkspace']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/juju2112/graylog2-images.git']]]

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
                expression
                {
                  params.Image_Type.contains("Build Beta OVA")
                }
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
                 checkout poll: false, scm: [$class: 'GitSCM', branches: [[name: "*/${params.BRANCH}"]], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'WipeWorkspace']], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/juju2112/graylog2-images.git']]]

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

                 s3Upload(workingDir:'packer/output-virtualbox-iso', bucket:'graylog2-releases', path:'graylog-omnibus/ova/', includePathPattern:'*.ova')
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
