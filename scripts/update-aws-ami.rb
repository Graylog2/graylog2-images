require 'pp'

# Takes the Jenkins AMI build output and updates the README file.
#
# Example Jenkins output:
#
# ap-northeast-1: ami-0b4212dee8836018f
# ap-southeast-1: ami-077e1fb0c932ac2c6
# ap-southeast-2: ami-0bfbe34c7b5105ff3
# eu-central-1: ami-08ff4fbd160758b90
# eu-west-1: ami-052781e76cf0015e9
# eu-west-2: ami-07279cdc721d81f13
# eu-west-3: ami-05dd423f7d235cfca
# sa-east-1: ami-00c2d5c3a2453e653
# us-east-1: ami-067705ee92d398b47
# us-east-2: ami-01d2cdd8801a912ed
# us-west-1: ami-0cd6ad478069f1cbe
# us-west-2: ami-06b31dedf53142a0f
#
# Put that into a file and call this script with the filename and graylog version
# as arguments.

readme_file = 'aws/README.md'

images = {}

filename = ARGV.shift
version = ARGV.shift

if filename.nil? or version.nil?
  puts "Usage: update-aws-ami.rb <filename> <graylog-version>"
  exit 1
end

File.readlines(filename).each do |line|
  region, ami = line.chomp.split(': ', 2)

  images[region] = ami
end

pp images

readme = File.readlines(readme_file)

readme.clone.each_with_index do |line, idx|
  images.each do |region, ami|
    if line.include?(region)
      readme[idx].gsub!(/ami-\w+/, ami)
      readme[idx].gsub!(/\d+\.\d+\.\d+/, version)
    end
  end
end

File.write(readme_file, readme.join(''))
