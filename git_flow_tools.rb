#!/usr/bin/env ruby
require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'timeout'
require 'json'
require 'yaml'
require 'pp'

class Net::HTTP::Patch < Net::HTTPRequest
  METHOD = 'PATCH'
  REQUEST_HAS_BODY = true
  RESPONSE_HAS_BODY = true
end

class Git_flow_tools

def self.get_issues(conf, user, repo)
  uri              = URI.parse('https://api.github.com')
  http             = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl     = true if uri.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  path                = URI.escape("/repos/#{user}/#{repo}/issues")
  req                 = Net::HTTP::Get.new(path)
  req['Content-Type'] = 'application/json'
  req['Accept']       = 'application/json'
  
  begin
    Timeout::timeout(30) { JSON.parse http.request(req).body }
  rescue Exception => e
    puts "Failed to contact github #{e}"
  end
end

def self.get_issue(conf, user, repo, number)
  uri              = URI.parse('https://api.github.com')
  http             = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl     = true if uri.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  path                = URI.escape("/repos/#{user}/#{repo}/issues/#{number}")
  req                 = Net::HTTP::Get.new(path)
  req['Content-Type'] = 'application/json'
  req['Accept']       = 'application/json'
  
  begin
    Timeout::timeout(30) { JSON.parse http.request(req).body }
  rescue Exception => e
    puts "Failed to contact github #{e}"
  end
end

def self.edit_issue(conf, user, repo, number, data)
  git_hub_auth_token = conf['git_hub_auth_token']

  uri              = URI.parse('https://api.github.com')
  http             = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl     = true if uri.scheme == 'https'
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  path                 = URI.escape("/repos/#{user}/#{repo}/issues/#{number}")
  req                  = Net::HTTP::Patch.new(path)
  req['Content-Type']  = 'application/json'
  req['Accept']        = 'application/json'
  req['Authorization'] = "token #{git_hub_auth_token}"
  req.body             = data

  begin
    Timeout::timeout(30) { JSON.parse http.request(req).body }
  rescue Exception => e
    puts "Failed to contact github #{e}"
  end
end

end

conf = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'git_flow_tools.conf'))
repo_url = `git config --get remote.origin.url`
repo_user = repo_url.split('/')[-2].strip
repo_name = repo_url.split('/')[-1].gsub('.git','').strip

repo_user = 'icalvete'
repo_name = 'test'

user_email = `git config --get user.email`
user = user_email.split('@')[0]

case ARGV[0]

when 'get_issues'

  issues = Git_flow_tools.get_issues(conf, repo_user, repo_name)
  issues.sort! { |a,b| a['number'] <=> b['number'] }

  if issues.length == 0
      exit 1
  end

  out = ' '

  issues.each do |issue|

    assignee = ''
    if issue['assignee'] 
      assignee = ' (asigned to: ' +  issue['assignee']['login'] + ')' 
    end

    out += issue['number'].to_s + ' - ' +  issue['title'] + assignee + '\n'
  end

  puts out

when 'get_issue'

  issue = Git_flow_tools.get_issue(conf, repo_user, repo_name, ARGV[1])
  if issue['state'] == 'open'
    puts issue['title']
  else
    exit 1
  end

when 'set_issue'
  data = '{"body": "Assigned to ' + user + '", "assignee": "' + user + '", "state": "open"}'
  issue = Git_flow_tools.edit_issue(conf, repo_user, repo_name, ARGV[1], data)

when 'close_issue'
  data = '{"body": "Assigned to ' + user + '", "assignee": "' + user + '", "state": "closed"}'
  issue = Git_flow_tools.edit_issue(conf, repo_user, repo_name, ARGV[1], data)

else
end
