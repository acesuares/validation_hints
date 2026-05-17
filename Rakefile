# frozen_string_literal: true

require "bundler/setup"
require "bundler/gem_helper"
require "rake/testtask"

Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
end

task default: :test
