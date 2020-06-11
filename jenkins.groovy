pipeline
{
   agent none

   options
   {
      buildDiscarder logRotator(artifactDaysToKeepStr: '30', artifactNumToKeepStr: '100', daysToKeepStr: '30', numToKeepStr: '100')
      timestamps()
      withAWS(region:'eu-west-1', credentials:'aws-key-releases')
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
             docker
             {
               label 'linux'
               image 'hashicorp/packer:latest'
             }
           }
           when
           {
             beforeAgent true
             expression
             {
               params.Image_Type.contains("Build AMI")
             }
           }
           steps
           {
              validateParameters()
              echo "params: ${params}"
              echo "Choice: ${params.Image_Type}"
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
             }
             steps
             {
                validateParameters()
                echo "Choice: ${params.Image_Type}"

                dir('packer')
                {
                  sh '''
                  bundle install --path .bundle
                  packer build virtualbox.json
                  cd output-virtualbox-iso
                  bundle exec ../ovf2ova.rb graylog.ovf
                  mv graylog.ova graylog-${params.Graylog_Version}.ova
                  '''
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
              }
              steps
              {
                 validateParameters()
                 echo "Choice: ${params.Image_Type}"
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
