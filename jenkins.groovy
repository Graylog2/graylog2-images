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
      buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '100', daysToKeepStr: '30', numToKeepStr: '100')
      timestamps()
   }

   parameters
   {
       string(name: 'Graylog_Version', defaultValue: '', description: '2.x: 2.5.0-beta.1-1 (the git tag in graylog2-images) | 3.x: 3.0.0-4.alpha.4 (the deb package version)')

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

              dir('packer')
              {
                sh 'packer version'

                withAWS(region:'eu-west-1', credentials:'aws-ec2-ami-creator')
                {
                  sh 'packer build aws.json'
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
