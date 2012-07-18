module ActiveModel
  # == Active Model Hints
  #
  # more documentation needed

  class Hints
    include Enumerable

    CALLBACKS_OPTIONS = [:if, :unless, :on, :allow_nil, :allow_blank, :strict]
    MESSAGES_FOR_VALIDATORS = %w(confirmation acceptance presence uniqueness format inclusion exclusion associated numericality)
    MESSAGES_FOR_OPTIONS = %w(within in is minimum maximum greater_than greater_than_or_equal_to equal_to less_than less_than_or_equal_to odd even)

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

    def validation_hints_for(attribute)
      @base.class.validators_on(attribute).map do |v|
        validator = v.class.to_s.split('::').last.downcase.gsub('validator','')
        if MESSAGES_FOR_VALIDATORS.include?(validator)
          generate_keys(attribute, validator)
        end
      end.flatten.compact
                                #        key = v.class.to_s.underscore.gsub('/','.')
                                #        puts "************#{v.inspect}"
                                #        key = [v.qualifier, key].join('.') if v.respond_to?(:qualifier)
                                #        [ key, v.options.except(*CALLBACKS_OPTIONS).keys.map do |o|
                                #            key + "." + o.to_s
                                #          end ].flatten
    end

    def generate_keys(attribute, type)

      if @base.class.respond_to?(:i18n_scope)
        defaults = @base.class.lookup_ancestors.map do |klass|
          [ :"#{@base.class.i18n_scope}.hints.models.#{klass.model_name.i18n_key}.attributes.#{attribute}.#{type}",
            :"#{@base.class.i18n_scope}.hints.models.#{klass.model_name.i18n_key}.#{type}" ]
        end
      else
        defaults = []
      end

      defaults << :"#{@base.class.i18n_scope}.hints.messages.#{type}" if @base.class.respond_to?(:i18n_scope)
      defaults << :"hints.attributes.#{attribute}.#{type}"
      defaults << :"hints.messages.#{type}"

      defaults.compact!
      defaults.flatten!

      #key = defaults.shift

      options = {
        :default => defaults,
        :model => @base.class.model_name.human,
        :attribute => @base.class.human_attribute_name(attribute),
      }
      puts "*" + File.basename(__FILE__) + ": " + "ATTR #{attribute}, OPTIONS #{options.inspect} "
      #I18n.translate(key, options)
      [ defaults, options ]
    end


  end

end
