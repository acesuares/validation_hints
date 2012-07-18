# -*- encoding : utf-8 -*-

require 'validation_hints/version'
require 'active_model/hints'

module ActiveModel

  module Validations

    def has_validations?
      ! self.class.validators.empty?
    end

    def hints
      @hints ||= Hints.new(self)
    end

    def hints_for(attribute)
      hints.validation_hints_for(attribute)
    end

  end

end

require 'active_support/i18n'
I18n.load_path << File.dirname(__FILE__) + '/validation_hints/locale/en.yml'
