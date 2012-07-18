# -*- encoding : utf-8 -*-

require 'active_support'
require 'validation_hints/version'

module ActiveModel
  extend ActiveSupport::Autoload

  autoload :Hints

end

require 'active_support/i18n'
I18n.load_path << File.dirname(__FILE__) + '/validation_hints/locale/en.yml'
