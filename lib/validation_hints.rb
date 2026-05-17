# frozen_string_literal: true

require "validation_hints/version"
require "active_model/hints"

module ValidationHints
  LOCALE_PATH = File.expand_path("validation_hints/locale/en.yml", __dir__)

  def self.load_i18n!
    return if @i18n_loaded

    require "i18n"
    I18n.load_path << LOCALE_PATH unless I18n.load_path.include?(LOCALE_PATH)
    @i18n_loaded = true
  end
end

require "validation_hints/validations_patch"

if defined?(Rails::Railtie)
  require "validation_hints/railtie"
else
  require "active_model"
  ValidationHints::ValidationsPatch.apply!
  ValidationHints.load_i18n!
end
