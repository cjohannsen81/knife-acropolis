require 'chef/knife'
require 'digest'

class Chef
  class Knife
    module AcropolisBase
    
    def self.included(includer)
      includer.class_eval do
    
        deps do
          require 'chef/knife'
          require 'rest-client'
        end
      
        option :a_host,
        :short => "-H HOST",
        :long => "--acropolis-host HOST",
        :description => "Please enter the IP/hostname of the Nutanix Management API host.",
        :proc => Proc.new { |key| Chef::Config[:knife][:a_host] = key }
        
        option :a_pass,
        :short => "-P PASS",
        :long => "--acropolis-password PASS",
        :description => "Please enter the password of the Nutanix Management API user.",
        :proc => Proc.new { |key| Chef::Config[:knife][:a_pass] = key }
    
        option :a_user,
        :short => "-U USER",
        :long => "--acropolis-user USER",
        :description => "Please enter the IP/hostname of the Nutanix Management API host.",
        :proc => Proc.new { |key| Chef::Config[:knife][:a_user] = key }
    
    end
  end
  
  def validate
    unless Chef::Config[:knife][:a_user] && Chef::Config[:knife][:a_pass] && Chef::Config[:knife][:a_host]
      ui.error("Missing Credentials and/or host. Please use --help to see all available options.")
      exit 1
    end
  end

  def get(url)
    validate
      base_url = "https://"+ Chef::Config[:knife][:a_host] +":9440/api/nutanix/v0.8"+url
      puts "Trying to connect Acropolis on "+base_url 
      RestClient::Request.execute(
        :method => :get, 
        :url => base_url, 
        :content_type => 'json', 
        :accept => 'json', 
        :user => Chef::Config[:knife][:a_user], 
        :password => Chef::Config[:knife][:a_pass], 
        :verify_ssl => false
      ) 
  end
  
  def post(url,data)
    validate
      base_url = "https://"+ Chef::Config[:knife][:a_host] +":9440/api/nutanix/v0.8"+url
      puts "Trying to connect Acropolis on "+base_url 
      p data
      RestClient::Request.execute(
        :method => :post, 
        :url => base_url, 
        :payload => data,
        #Please note the change in the headers, POST will not work with other options (Error 512).
        :headers => {:accept => :json},
        :headers => {:content_type => :json},
        :user => Chef::Config[:knife][:a_user], 
        :password => Chef::Config[:knife][:a_pass], 
        :verify_ssl => false
        ) 
    end
    
    def delete(url,data)
    validate
        base_url = "https://"+ Chef::Config[:knife][:a_host] +":9440/api/nutanix/v0.8"+url
        puts "Trying to connect Acropolis on "+base_url 
        RestClient::Request.execute(
          :method => :delete, 
          :url => base_url + "/" + data,
          #Please note the change in the headers, POST will not work with other options (Error 512).
          :headers => {:accept => :json},
          :headers => {:content_type => :json},
          :user => Chef::Config[:knife][:a_user], 
          :password => Chef::Config[:knife][:a_pass], 
          :verify_ssl => false
          ) 
      end
    
  end
  
  
 end
end