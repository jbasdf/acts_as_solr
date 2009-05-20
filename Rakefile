require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

desc "Default Task"
task :default => [:test]

desc "Runs the unit tests"
task :test => "test:unit"

namespace :test do
  task :setup do
    ENV['RAILS_ENV'] = "test"
    require File.expand_path("#{File.dirname(__FILE__)}/config/solr_environment")
    puts "Using " + DB
    %x(mysql -u#{MYSQL_USER} < #{File.dirname(__FILE__) + "/test/fixtures/db_definitions/mysql.sql"}) if DB == 'mysql'

    Rake::Task["test:migrate"].invoke
  end
  
  desc 'Measures test coverage using rcov'
  task :rcov => :setup do
    rm_f "coverage"
    rm_f "coverage.data"
    rcov = "rcov --rails --aggregate coverage.data --text-summary -Ilib"
    
    system("#{rcov} --html #{Dir.glob('test/**/*_test.rb').join(' ')}")
    system("open coverage/index.html") if PLATFORM['darwin']
  end
  
  desc 'Runs the functional tests, testing integration with Solr'
  Rake::TestTask.new('functional' => :setup) do |t|
    t.pattern = "test/functional/*_test.rb"
    t.verbose = true
  end
  
  desc "Unit tests"
  Rake::TestTask.new(:unit) do |t|
    t.libs << 'test/unit'
    t.pattern = "test/unit/*_shoulda.rb"
    t.verbose = true
  end
end

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_dir = "rdoc"
  rd.rdoc_files.exclude("lib/solr/**/*.rb", "lib/solr.rb")
  rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "acts_as_solr"
    s.summary = "This plugin adds full text search capabilities and many other nifty features from Apache�s Solr to any Rails model. I'm currently rearranging the test suite to include a real unit test suite, and adding a few features I need myself."
    s.email = "meyer@paperplanes.de"
    s.homepage = "http://github.com/mattmatt/acts_as_solr"
    s.description = "This plugin adds full text search capabilities and many other nifty features from Apache�s Solr to any Rails model. I'm currently rearranging the test suite to include a real unit test suite, and adding a few features I need myself."
    s.authors = ["Mathias Meyer"]
    s.files =  FileList["[A-Z]*", "{bin,generators,lib,solr,test}/**/*"]
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end
