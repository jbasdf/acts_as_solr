ENV['RAILS_ENV']  = (ENV['RAILS_ENV'] || 'development').dup
# RAILS_ROOT isn't defined yet, so figure it out.
require "uri"
require "fileutils"
dir = File.dirname(__FILE__)
SOLR_PATH = File.expand_path("#{dir}/../solr") unless defined? SOLR_PATH

RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../test") unless defined? RAILS_ROOT
unless defined? SOLR_LOGS_PATH
  SOLR_LOGS_PATH = "#{RAILS_ROOT}/log"
  FileUtils.mkdir_p(SOLR_LOGS_PATH)
end
unless defined? SOLR_PIDS_PATH
  SOLR_PIDS_PATH = "#{RAILS_ROOT}/tmp/pids"
  FileUtils.mkdir_p(SOLR_PIDS_PATH)
end
unless defined? SOLR_DATA_PATH
  SOLR_DATA_PATH = "#{RAILS_ROOT}/solr/#{ENV['RAILS_ENV']}"
  FileUtils.mkdir_p(SOLR_DATA_PATH)
end

unless defined? SOLR_PORT
  config = YAML::load_file(RAILS_ROOT+'/config/solr.yml')
  
  SOLR_PORT = ENV['PORT'] || URI.parse(config[ENV['RAILS_ENV']]['url']).port
end

SOLR_JVM_OPTIONS = config[ENV['RAILS_ENV']]['jvm_options'] unless defined? SOLR_JVM_OPTIONS

if ENV["ACTS_AS_SOLR_TEST"]
  require "activerecord"
  DB = (ENV['DB'] ? ENV['DB'] : 'sqlite') unless defined?(DB)
  MYSQL_USER = (ENV['MYSQL_USER'].nil? ? 'root' : ENV['MYSQL_USER']) unless defined? MYSQL_USER
  require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'test', 'db', 'connections', DB, 'connection.rb')
end
