# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "minitest-metadata-patch"

Gem::Specification.new do |s|
  s.name        = "minitest-metadata-patch"
  s.version     = MinitestMetadataPatch::VERSION
  s.authors     = ["Ari Russo"]
  s.email       = ["ari@paperlesspost.com"]
  s.homepage    = "https://github.com/paperlesspost/minitest-metadata"
  s.summary     = %q{Patch for minitest-metadata}
  s.description = s.summary

  s.rubyforge_project = "minitest-metadata-patch"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "~> 0.6", ">= 0.6.0"
end
