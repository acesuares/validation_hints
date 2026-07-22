# frozen_string_literal: true

require "bundler/gem_helper"
require "rake/testtask"
require_relative "lib/validation_hints/version"

# Do not require "bundler/setup" at load time: `rake release` only builds and
# pushes the .gem (no tests, no sqlite3). Tests load the bundle explicitly.
Bundler::GemHelper.install_tasks

# Release git-push ALWAYS targets `origin` (GitHub) only.
#
# Bundler's stock `release` pushes the commit + tag to the CURRENT BRANCH's
# tracking remote (`git config branch.<branch>.remote`). If this repo is ever
# released from a branch that tracks `forgejo` (dev02, CI-only), the release
# would land there instead of GitHub. `origin` is the only place release
# commits/tags belong. Override `release` so its git-push step can never follow
# a non-origin tracking remote. Idempotent on the tag so a re-run after a failed
# push still lands the tag on origin.
Rake::Task["release"].clear if Rake::Task.task_defined?("release")

desc "Tag the release and push the commit + tag to origin (GitHub) only"
task "release:push_to_origin" do
  version = ValidationHints::VERSION
  tag     = "v#{version}"
  branch  = `git rev-parse --abbrev-ref HEAD`.strip
  unless system("git", "rev-parse", "-q", "--verify", "refs/tags/#{tag}",
                out: File::NULL, err: File::NULL)
    sh "git", "tag", tag
  end
  sh "git", "push", "origin", "refs/heads/#{branch}"
  sh "git", "push", "origin", "refs/tags/#{tag}"
end

desc "Build, tag, push to origin (GitHub) and push the gem to RubyGems"
task "release" => [ "build", "release:guard_clean",
                    "release:push_to_origin", "release:rubygem_push" ]

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.pattern = "test/**/*_test.rb"
end

task "test:bundle" do
  sh "bundle check > /dev/null 2>&1 || bundle install"
  require "bundler/setup"
end

Rake::Task[:test].enhance([ "test:bundle" ])

task default: :test
