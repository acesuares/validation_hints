# frozen_string_literal: true

require "test_helper"

class ValidationHintsTest < Minitest::Test
  def test_version
    assert_equal "6.4.0", ValidationHints::VERSION
  end

  def test_locale_path_exists
    assert File.file?(ValidationHints::LOCALE_PATH)
  end
end
