# frozen_string_literal: true

module ValidationHints
  module ValidationsPatch
    def self.apply!
      return if applied?

      ActiveModel::Validations::ClassMethods.module_eval do
        def has_validations?
          !validators.empty?
        end

        def has_validations_for?(attribute)
          !validators_on(attribute).empty?
        end
      end

      ActiveModel::Validations.module_eval do
        def has_validations?
          self.class.has_validations?
        end

        def has_validations_for?(attribute)
          self.class.has_validations_for?(attribute)
        end

        def hints
          @hints ||= ActiveModel::Hints.new(self)
        end
      end

      @applied = true
    end

    def self.applied?
      @applied
    end
  end
end
