require 'bundler'
Bundler.require

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'yard'
YARD::Rake::YardocTask.new

desc "Push a new version to Rubygems"
task :publish do
  require 'aws_cf_signer/version'

  sh "gem build aws_cf_signer.gemspec"
  sh "gem push aws_cf_signer-#{AwsCfSigner::VERSION}.gem"
  sh "rm aws_cf_signer-#{AwsCfSigner::VERSION}.gem"
end

task :default => :test
