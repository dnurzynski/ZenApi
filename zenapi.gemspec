# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zenapi/version"

Gem::Specification.new do |s|
  s.name        = "zenapi"
  s.version     = ZenApi::VERSION
  s.authors     = ["Damian Nurzyński"]
  s.email       = ["dnurzynski@gmail.com"]
  s.summary     = %q{agilzen api client}
  s.description = %q{Ruby client library for the agilezen.com api}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'webmock'

  s.add_runtime_dependency 'faraday',     '~> 0.8'
  s.add_runtime_dependency 'multi_json',  '~> 1.0'
end
