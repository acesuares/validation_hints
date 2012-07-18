module ActiveModel
  # == Active Model Hints
  #
  # more documentation needed

  class Hints
    include Enumerable

    attr_reader :messages

    # Pass in the instance of the object that is using the errors object.
    #
    #   class Person
    #     def initialize
    #       @errors = ActiveModel::Errors.new(self)
    #     end
    #   end
    def initialize(base)
      @base     = base
      @messages = ActiveSupport::OrderedHash.new
    end

    def initialize_dup(other)
      @messages = other.messages.dup
    end

# Backport dup from 1.9 so that #initialize_dup gets called
    unless Object.respond_to?(:initialize_dup)
      def dup # :nodoc:
        copy = super
        copy.initialize_dup(self)
        copy
      end
    end

    # Clear the messages
    def clear
      messages.clear
    end

    def show
      self
    end

    def t(a)
      a
    end
    
    def validation_help_for(attribute)
      @base.class.validators_on(attribute).map do |v|
        key = v.class.to_s.underscore
        regex = /\//
        main_key = key.match(regex) ? key.gsub('/','.') : "inline_forms.validations." + key
        [ t(main_key), v.options.keys.map do |o|
            t(main_key + "." + o.to_s)
          end ].flatten
      end.flatten.compact
    end

  end

end
