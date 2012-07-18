# -*- encoding : utf-8 -*-

require 'validation_hints/version'
require 'active_model/hints'

module ActiveModel
  module Validations
    def hints
      @hints ||= Hints.new(self)
    end
  end
end

require 'active_support/i18n'
I18n.load_path << File.dirname(__FILE__) + '/validation_hints/locale/en.yml'
