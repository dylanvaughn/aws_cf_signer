# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "aws_cf_signer/version"

Gem::Specification.new do |s|
  s.name        = "aws_cf_signer"
  s.version     = AwsCfSigner::VERSION
  s.authors     = ["Dylan Vaughn"]
  s.email       = ["dylancvaughn@gmail.com"]
  s.homepage    = "https://github.com/dylanvaughn/aws_cf_signer"
  s.summary     = "Ruby gem for signing AWS Cloudfront URLs for serving private content."

  s.add_development_dependency("rake", "~> 10.1")
  s.add_development_dependency("thoughtbot-shoulda", "~> 2.11")
  s.add_development_dependency("yard", "~> 0.8")

  s.files       = Dir.glob("lib/**/*") + %w(README.md)
end
