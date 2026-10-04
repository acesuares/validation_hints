# frozen_string_literal: true

require "delegate"
require "rubygems/package"

# Build-time only (loaded by validation_hints.gemspec): package every file
# world-readable, 0755 if the owner may execute it, else 0644.
#
# RubyGems packages each file's on-disk mode (File.lstat) and `gem install`
# restores it. The dev checkout is group-only (rw-rw----), so 8.1.53 shipped
# every file as 0660: only the installing user and group could read the
# installed gem, and a Docker image that installs as root and runs as another
# user could not load it. Same fix as InlineFormsGemFiles in inline_forms.
module ValidationHints
  module GemBuild
    module_function

    def packaged_mode(mode)
      (mode & 0o100).zero? ? 0o644 : 0o755
    end

    class ReadableTar < SimpleDelegator
      def add_file_simple(name, mode, size, &block)
        __getobj__.add_file_simple(name, GemBuild.packaged_mode(mode), size, &block)
      end
    end

    module ReadablePackage
      def add_files(tar)
        super(ReadableTar.new(tar))
      end
    end
  end
end

Gem::Package.prepend(ValidationHints::GemBuild::ReadablePackage) unless Gem::Package <= ValidationHints::GemBuild::ReadablePackage
