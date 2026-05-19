# frozen_string_literal: true

module ActiveModel
  # Introspects declared validators and builds proactive hint messages (before +valid?+ fails).
  #
  # Conditional options (+:if+, +:unless+, +:on+) are not evaluated; hints reflect static rules.
  # For +format+ validators, prefer a custom +message:+ or per-attribute I18n keys.
  class Hints
    include Enumerable

    MESSAGES_FOR_OPTIONS = %w[
      within in is minimum maximum greater_than greater_than_or_equal_to
      equal_to less_than less_than_or_equal_to odd even only_integer
    ].freeze

    VALIDATORS_WITHOUT_MAIN_KEYS = %w[exclusion format inclusion length numericality].freeze

    RANGE_OPTIONS = %w[within in].freeze

    attr_reader :messages

    def initialize(base)
      @base = base
      @messages = {}
      attribute_names_for_hints.each do |attribute|
        @messages[attribute] = hints_for(attribute)
      end
    end

    def hints_for(attribute)
      attribute = attribute.to_sym
      result = []
      @base.class.validators_on(attribute).each do |validator|
        result.concat(messages_for_validator(attribute, validator))
      end
      result
    end

    def full_messages_for(attribute)
      hints_for(attribute).map { |message| full_message(attribute, message) }
    end

    def initialize_dup(other)
      @messages = other.messages.transform_values(&:dup)
    end

    def clear
      messages.clear
    end

    def include?(attribute)
      (value = messages[attribute.to_sym]) && value.any?
    end
    alias has_key? include?

    def get(key)
      messages[key]
    end

    def set(key, value)
      messages[key] = value
    end

    def delete(key)
      messages.delete(key)
    end

    def [](attribute)
      get(attribute.to_sym) || set(attribute.to_sym, [])
    end

    def []=(attribute, hint)
      self[attribute] << hint
    end

    def each
      messages.each_key do |attribute|
        self[attribute].each { |hint| yield attribute, hint }
      end
    end

    def size
      values.flatten.size
    end

    def values
      messages.values
    end

    def keys
      messages.keys
    end

    def to_a
      full_messages
    end

    def count
      to_a.size
    end

    def empty?
      messages.values.all?(&:empty?)
    end
    alias_method :blank?, :empty?

    def to_xml(options = {})
      to_a.to_xml(options.reverse_merge(root: "hints", skip_types: true))
    end

    def as_json(_options = nil)
      to_hash
    end

    def to_hash
      messages.dup
    end

    def add(attribute, message = :invalid, options = {})
      message = normalize_message(attribute, message, options)
      if options[:strict]
        raise ActiveModel::StrictValidationFailed, full_message(attribute, message)
      end

      self[attribute] << message
    end

    def add_on_empty(attributes, options = {})
      Array(attributes).each do |attribute|
        value = @base.send(:read_attribute_for_validation, attribute)
        is_empty = value.respond_to?(:empty?) ? value.empty? : false
        add(attribute, :empty, options) if value.nil? || is_empty
      end
    end

    def add_on_blank(attributes, options = {})
      Array(attributes).each do |attribute|
        value = @base.send(:read_attribute_for_validation, attribute)
        add(attribute, :blank, options) if value.blank?
      end
    end

    def added?(attribute, message = :invalid, options = {})
      message = normalize_message(attribute, message, options)
      self[attribute].include?(message)
    end

    def full_messages
      map { |attribute, message| full_message(attribute, message) }
    end

    def full_message(attribute, message)
      return message if attribute == :base

      attr_name = attribute.to_s.tr(".", "_").humanize
      attr_name = @base.class.human_attribute_name(attribute, default: attr_name, base: @base)

      format_defaults = i18n_format_defaults
      format_key = format_defaults.shift

      I18n.t(
        format_key,
        default: format_defaults,
        attribute: attr_name,
        message: message
      )
    end

    def generate_message(attribute, type, options = {})
      options = options.dup
      type = options.delete(:message) if options[:message].is_a?(Symbol)
      value = (attribute != :base ? @base.read_attribute_for_validation(attribute) : nil)

      interpolation = {
        model: @base.model_name.human,
        attribute: @base.class.human_attribute_name(attribute, base: @base),
        value: value,
        object: @base,
        count: options[:count],
        minimum: options[:minimum],
        maximum: options[:maximum]
      }.compact

      defaults = i18n_defaults(attribute, type, options)
      key = defaults.shift

      I18n.translate(key, **interpolation.merge(default: defaults))
    end

    private

    def attribute_names_for_hints
      from_record =
        if @base.respond_to?(:attributes)
          @base.attributes.keys
        else
          []
        end

      from_validators = @base.class.validators.flat_map(&:attributes).map(&:to_s)
      (from_record + from_validators).map(&:to_sym).uniq
    end

    def messages_for_validator(attribute, validator)
      key = validator_key(validator)
      options = validator.options.dup
      result = []

      if options[:allow_blank] && key == "presence"
        return result
      end

      if options[:message].is_a?(Symbol)
        message_key = "#{key}.#{options[:message]}"
        generate_options = options.dup
        generate_options.delete(:message)
        result << generate_message(attribute, message_key, generate_options)
        return result
      end

      message_key = key
      message_key = "numericality.must_be_a_number" if key == "numericality"
      unless VALIDATORS_WITHOUT_MAIN_KEYS.include?(key)
        result << generate_message(attribute, message_key, options)
      end

      if key == "length" && options[:minimum] && options[:maximum]
        result << generate_message(
          attribute,
          "length.within",
          minimum: options[:minimum],
          maximum: options[:maximum]
        )
        return result
      end

      options.each do |option, value|
        next unless MESSAGES_FOR_OPTIONS.include?(option.to_s)

        if RANGE_OPTIONS.include?(option.to_s) && value.is_a?(Range)
          result.concat(range_hint_messages(attribute, key, value))
        else
          count = inclusion_exclusion_count(key, value)
          result << generate_message(
            attribute,
            "#{key}.#{option}",
            options.merge(count: count)
          )
        end
      end

      result
    end

    def range_hint_messages(attribute, validator_key, range)
      minimum = range.min
      maximum = range.max
      maximum -= 1 if range.exclude_end?

      if validator_key == "length"
        [
          generate_message(attribute, "#{validator_key}.within", minimum: minimum, maximum: maximum),
        ]
      else
        [
          generate_message(attribute, "#{validator_key}.minimum", count: minimum),
          generate_message(attribute, "#{validator_key}.maximum", count: maximum)
        ]
      end
    end

    def inclusion_exclusion_count(validator_key, value)
      return value.to_sentence if %w[inclusion exclusion].include?(validator_key) && value.respond_to?(:to_sentence)

      value
    end

    def validator_key(validator)
      validator.class.name.demodulize.underscore.delete_suffix("_validator")
    end

    def i18n_defaults(attribute, type, options)
      attribute_name = attribute.to_s.remove(/\[\d+\]/)

      defaults = model_hint_defaults(attribute_name, type)
      defaults << options[:message] if options[:message]

      if @base.class.respond_to?(:i18n_scope)
        scope = @base.class.i18n_scope
        defaults << :"#{scope}.hints.messages.#{type}"
      end

      defaults << :"activemodel.hints.messages.#{type}"
      defaults << :"hints.attributes.#{attribute_name}.#{type}"
      defaults << :"hints.messages.#{type}"
      defaults.compact.flatten
    end

    def model_hint_defaults(attribute_name, type)
      return [] unless @base.class.respond_to?(:i18n_scope)

      scope = @base.class.i18n_scope
      @base.class.lookup_ancestors.flat_map do |klass|
        [
          :"#{scope}.hints.models.#{klass.model_name.i18n_key}.attributes.#{attribute_name}.#{type}",
          :"#{scope}.hints.models.#{klass.model_name.i18n_key}.#{type}"
        ]
      end
    end

    def i18n_format_defaults
      defaults = []

      if @base.class.respond_to?(:i18n_scope)
        scope = @base.class.i18n_scope
        @base.class.lookup_ancestors.each do |klass|
          defaults << :"#{scope}.hints.models.#{klass.model_name.i18n_key}.format"
        end
        defaults << :"#{scope}.hints.format"
      end

      defaults << :"activemodel.hints.format"
      defaults << :"hints.format"
      defaults << "%{attribute} %{message}"
    end

    def normalize_message(attribute, message, options = {})
      case message
      when Symbol
        generate_message(attribute, message, options)
      when Proc
        message.call
      when nil
        generate_message(attribute, :invalid, options)
      else
        message
      end
    end
  end
end
