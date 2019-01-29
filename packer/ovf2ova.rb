#!/usr/bin/env ruby

require 'nokogiri'
require 'nokogiri-pretty'

if ARGV.first.nil? or not File.exists? ARGV.first
  puts "Usage: ovf2ova.rb <file.ovf>"
  exit 1
end

doc = Nokogiri::XML(File.open(ARGV.first))

namespaces = Hash.new
doc.collect_namespaces.each_pair do |key, value|
  namespaces[key.sub(/^xmlns:/, '')] = value
end

# remove Virtualbox specific section
doc.xpath("//vbox:Machine", namespaces).remove

# set compatible VirtualSystemType
doc.at_xpath("/xmlns:Envelope/ovf:VirtualSystem/ovf:VirtualHardwareSection/ovf:System/vssd:VirtualSystemType",
             namespaces).content = "vmx-07"

# Virtualbox and VMware Player/Fusion act as network bridge with these settings
doc.at_xpath("/xmlns:Envelope/ovf:NetworkSection/ovf:Network").set_attribute('ovf:name', 'NAT Network')
doc.at_xpath("/xmlns:Envelope/ovf:VirtualSystem/ovf:VirtualHardwareSection/ovf:Item[rasd:ResourceType=10]/rasd:Connection").content = "NAT Network"
doc.at_xpath("/xmlns:Envelope/ovf:VirtualSystem/ovf:VirtualHardwareSection/ovf:Item[rasd:ResourceType=10]/rasd:ResourceSubType").content = "vmxnet3"

# Remove unnecessary sound card and disk controllers
doc.at_xpath("/xmlns:Envelope/ovf:VirtualSystem/ovf:VirtualHardwareSection/ovf:Item[rasd:ResourceType=35]").remove
doc.at_xpath("/xmlns:Envelope/ovf:VirtualSystem/ovf:VirtualHardwareSection/ovf:Item[rasd:ResourceType=5]").remove

File.open(ARGV.first,'w') do |f|
  f.puts doc.human
end

system("ovftool --overwrite --powerOn --diskMode=thin -tt=ova #{ARGV.first} .")
