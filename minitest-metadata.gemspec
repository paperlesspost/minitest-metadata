# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "minitest-metadata"

Gem::Specification.new do |s|
  s.name        = "minitest-metadata-filters"
  s.version     = Minitest::Metadata::Filters::VERSION
  s.authors     = ["Aaron Quint"]
  s.email       = ["aaron@paperlesspost.com"]
  s.homepage    = ""
  s.summary     = %q{Add filters to minitest-metadata}
  s.description = s.summary

  s.rubyforge_project = "minitest-metadata-filters"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "minitest-metadata", "0.6.0"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest", "5.5.0"
end
