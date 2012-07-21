# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "validation_hints/version"

Gem::Specification.new do |s|
  s.name        = "validation_hints"
  s.version     = ValidationHints::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ace Suares"]
  s.email       = ["ace@suares.com"]
  s.homepage    = %q{http://github.com/acesuares/validation_hints}
  s.summary     = %q{Validation Hints.}
  s.description = %q{Hints for validation.}
  s.licenses    = ["MIT"]

  s.rubyforge_project = "validation_hints"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency(%q<rspec-rails>, [">= 0"])
  s.add_development_dependency(%q<shoulda>, [">= 0"])
  s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
  s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
  s.add_development_dependency(%q<rcov>, [">= 0"])

end
