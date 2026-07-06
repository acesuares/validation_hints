# frozen_string_literal: true

require "test_helper"

class ValidationHintsTest < Minitest::Test
  # Lockstep releases bump VERSION without touching this gem's code, so pin the
  # 8.1 line rather than an exact patch (which broke on the 8.1.21 bump).
  def test_version
    assert_match(/\A8\.1\.\d+\z/, ValidationHints::VERSION)
  end

  def test_locale_path_exists
    assert File.file?(ValidationHints::LOCALE_PATH)
  end
end
