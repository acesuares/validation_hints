# frozen_string_literal: true

require "bundler/gem_helper"
require "rake/testtask"

# Do not require "bundler/setup" at load time: `rake release` only builds and
# pushes the .gem (no tests, no sqlite3). Tests load the bundle explicitly.
Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
end

task "test:bundle" do
  sh "bundle check > /dev/null 2>&1 || bundle install"
  require "bundler/setup"
end

Rake::Task[:test].enhance(["test:bundle"])

task default: :test
