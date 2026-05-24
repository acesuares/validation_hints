# frozen_string_literal: true

require "test_helper"

class ValidationHintsTest < Minitest::Test
  def test_version
    assert_equal "8.0.4", ValidationHints::VERSION
  end

  def test_locale_path_exists
    assert File.file?(ValidationHints::LOCALE_PATH)
  end
end
