# frozen_string_literal: true

require "validation_hints/version"
require "active_model/hints"

module ValidationHints
  LOCALE_PATH = File.expand_path("validation_hints/locale/en.yml", __dir__)
  # Every shipped locale (en, nl). A host's own files load later and win.
  LOCALE_PATHS = Dir[File.expand_path("validation_hints/locale/*.yml", __dir__)].sort.freeze

  def self.load_i18n!
    return if @i18n_loaded

    require "i18n"
    LOCALE_PATHS.each { |path| I18n.load_path << path unless I18n.load_path.include?(path) }
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
