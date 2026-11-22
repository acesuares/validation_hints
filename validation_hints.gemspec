# frozen_string_literal: true

require_relative "lib/validation_hints/version"
# Build-time: package world-readable file modes (see ValidationHints::GemBuild).
require_relative "lib/validation_hints/gem_build"

Gem::Specification.new do |s|
  s.name        = "validation_hints"
  s.version     = ValidationHints::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = [ "Ace Suares" ]
  s.email       = [ "ace@suares.com" ]
  s.homepage    = "https://github.com/acesuares/validation_hints"
  s.summary     = "Proactive validation hints derived from model validators"
  s.description = "Shows what a field expects before validation fails — complementary to ActiveModel errors."
  s.license     = "MIT"
  s.required_ruby_version = ">= 4.0.0"

  # What an installed gem needs; not the tests, CI and RuboCop files or stuff/.
  s.files = Dir.chdir(__dir__) do
    Dir.glob("lib/**/*").select { |f| File.file?(f) } +
      %w[README.md LICENSE.txt CHANGELOG.md validation_hints.gemspec]
  end

  s.require_paths = [ "lib" ]

  s.add_dependency "activerecord", ">= 8.1", "< 8.2"

  s.add_development_dependency "activerecord", ">= 8.1", "< 8.2"
  s.add_development_dependency "activemodel", ">= 8.1", "< 8.2"
  s.add_development_dependency "sqlite3", ">= 2.1"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "rake", "~> 13.0"
  s.add_development_dependency "bundler", ">= 2.0"
  # Rails omakase style; offenses grandfathered in .rubocop_todo.yml.
  s.add_development_dependency "rubocop-rails-omakase"
end
