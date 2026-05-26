# frozen_string_literal: true

require_relative "lib/validation_hints/version"

Gem::Specification.new do |s|
  s.name        = "validation_hints"
  s.version     = ValidationHints::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ace Suares"]
  s.email       = ["ace@suares.com"]
  s.homepage    = "https://github.com/acesuares/validation_hints"
  s.summary     = "Proactive validation hints derived from model validators"
  s.description = "Shows what a field expects before validation fails — complementary to ActiveModel errors."
  s.license     = "MIT"
  s.required_ruby_version = ">= 4.0.0"

  if File.directory?(File.join(__dir__, ".git"))
    s.files      = `git ls-files`.split("\n")
    s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  else
    s.files = Dir.chdir(__dir__) do
      Dir.glob("{lib,test}/**/*", File::FNM_DOTMATCH).reject do |f|
        f.end_with?(".gem") || f.start_with?("stuff/")
      end + %w[README.md LICENSE.txt CHANGELOG.md Gemfile Rakefile validation_hints.gemspec]
    end
    s.test_files = Dir.glob("{test,spec}/**/*", base: __dir__)
  end

  s.require_paths = ["lib"]

  s.add_dependency "activerecord", ">= 8.1", "< 8.2"

  s.add_development_dependency "activerecord", ">= 8.1", "< 8.2"
  s.add_development_dependency "activemodel", ">= 8.1", "< 8.2"
  s.add_development_dependency "sqlite3", ">= 2.1"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "bundler", ">= 2.0"
end
