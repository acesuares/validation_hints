# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "zlib"
require_relative "../lib/validation_hints/gem_build"

# 8.1.53 shipped every file as 0660 (the checkout's group-only modes), so an
# installed gem was unreadable for anyone outside the installing user and
# group. Gem builds now package 0644 / 0755 whatever the on-disk modes.
class GemBuildTest < Minitest::Test
  REPO_ROOT = File.expand_path("..", __dir__)

  def packaged_modes(gem_path)
    modes = {}
    File.open(gem_path, "rb") do |io|
      Gem::Package::TarReader.new(io).each do |entry|
        next unless entry.full_name == "data.tar.gz"

        Gem::Package::TarReader.new(Zlib::GzipReader.new(entry)).each do |file|
          modes[file.full_name] = file.header.mode & 0o777
        end
      end
    end
    modes
  end

  def build(spec, dir, gem_dir)
    gem_path = File.join(gem_dir, "#{spec.full_name}.gem")
    Dir.chdir(dir) do
      package = Gem::Package.new(gem_path)
      package.spec = spec
      Gem::DefaultUserInteraction.use_ui(Gem::SilentUI.new) { package.build(true) }
    end
    gem_path
  end

  def test_group_only_files_are_packaged_world_readable
    Dir.mktmpdir do |src|
      Dir.mktmpdir do |out|
        File.write(File.join(src, "plain.rb"), "# plain\n")
        File.write(File.join(src, "tool"), "#!/bin/sh\n")
        File.chmod(0o660, File.join(src, "plain.rb"))
        File.chmod(0o700, File.join(src, "tool"))

        spec = Gem::Specification.new do |s|
          s.name = "modes_probe"
          s.version = "0.0.1"
          s.summary = "probe"
          s.authors = [ "probe" ]
          s.files = %w[plain.rb tool]
        end

        modes = packaged_modes(build(spec, src, out))

        assert_equal({ "plain.rb" => 0o644, "tool" => 0o755 }, modes)
      end
    end
  end

  def test_the_gemspec_packages_world_readable_files
    path = File.join(REPO_ROOT, "validation_hints.gemspec")
    spec = Gem::Specification.load(path)
    refute_nil spec

    Dir.mktmpdir do |out|
      modes = packaged_modes(build(spec, REPO_ROOT, out))

      refute_empty modes
      unreadable = modes.reject { |_, mode| (mode & 0o444) == 0o444 }
      assert_empty unreadable, "not world-readable in the .gem"
    end
  end
end
