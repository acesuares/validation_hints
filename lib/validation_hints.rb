# -*- encoding : utf-8 -*-

require 'validation_hints/version'
require 'active_model/hints'

module ActiveModel

  module Validations

    module ClassMethods

      def has_validations?
        ! self.validators.empty?
      end

      def has_validations_for?(attribute)
        ! self.validators_on(attribute).empty?
      end

    end

    def has_validations?
      self.class.has_validations?
    end

    def has_validations_for?(attribute)
      self.class.has_validations_for?(attribute)
    end

    def hints
      @hints ||= Hints.new(self)
    end

  end

end

require 'active_support/i18n'
I18n.load_path << File.dirname(__FILE__) + '/validation_hints/locale/en.yml'
