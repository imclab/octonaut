require 'gli'
require 'octokit'
require 'octonaut/printer'
require 'octonaut/version'

module Octonaut
  extend GLI::App
  extend Octonaut::Printer

  OCTOKIT_CONFIG_KEYS = [:netrc, :login, :password, :oauth_token]

  program_desc 'Octokit-powered CLI for GitHub'
  commands_from 'octonaut/commands'
  commands_from File.join(ENV['HOME'], '.octonaut', 'plugins')


  desc 'Use .netrc file for authentication'
  default_value false
  switch [:n, :netrc]

  desc 'GitHub login'
  flag [:u, :login]
  desc 'GitHub password'
  flag [:p, :password], :mask => true
  desc 'GitHub API token'
  flag [:t, :oauth_token, :token], :mask => true


  pre do |global,command,options,args|
    # Pre logic here
    # Return true to proceed; false to abourt and not call the
    # chosen command
    # Use skips_pre before a command to skip this block
    # on that command only

    @client = client(global, options)
    true
  end

  post do |global,command,options,args|
    # Post logic here
    # Use skips_post before a command to skip this
    # block on that command only
  end

  on_error do |exception|
    # Error logic here
    # return false to skip default error handling
    true
  end

  def self.client(global, options)
    opts = global.merge(options).
      select {|k, v| OCTOKIT_CONFIG_KEYS.include?(k) }
    Octokit::Client.new(opts)
  end

end
