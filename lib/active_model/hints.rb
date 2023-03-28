module ActiveModel
  # == Active Model Hints
  #
  # p = Person.new
  # p.hints
  # p.hints[:name]
  # 
  # more documentation needed

  class Hints
    include Enumerable

    CALLBACKS_OPTIONS = [:if, :unless, :on, :allow_nil, :allow_blank, :strict]
    MESSAGES_FOR_VALIDATORS = %w(confirmation acceptance presence uniqueness format associated numericality)
    VALIDATORS_WITHOUT_MAIN_KEYS = %w(exclusion format inclusion length numericality)
    # and these? validates_with validates_each
    MESSAGES_FOR_OPTIONS = %w(within in is minimum maximum greater_than greater_than_or_equal_to equal_to less_than less_than_or_equal_to odd even only_integer)
    OPTIONS_THAT_WE_DONT_USE_YET = {
      :acceptance => :acceptance

    }
    VALIDATORS_THAT_WE_DONT_KNOW_WHAT_TO_DO_WITH = %w(validates_associated)

    # Should virtual element for
    #  validates :email, :confirmation => true
    #  validates :email_confirmation, :presence => true
    # also have a hint?

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
      @base.attributes.keys.each do |a|
        @messages[a.to_sym] = hints_for(a.to_sym)
      end
    end

    def hints_for(attribute)
      result = Array.new
      @base.class.validators_on(attribute).map do |v|
        validator = v.class.to_s.split('::').last.underscore.gsub('_validator','')
        if v.options[:message].is_a?(Symbol)
          message_key =  [validator, v.options[:message]].join('.') # if a message was supplied as a symbol, we use it instead
          result << generate_message(attribute, message_key, v.options)
        else
          message_key =  validator
          message_key =  [validator, ".must_be_a_number"].join('.') if validator == 'numericality' # create an option for numericality; the way YAML works a key (numericality) with subkeys (greater_than, etc etc) can not have a string itself. So we create a subkey for numericality
          result << generate_message(attribute, message_key, v.options) unless VALIDATORS_WITHOUT_MAIN_KEYS.include?(validator)
          v.options.each do |o|
            if MESSAGES_FOR_OPTIONS.include?(o.first.to_s)
              count = o.last
              count = (o.last.to_sentence if %w(inclusion exclusion).include?(validator)) rescue o.last
              result << generate_message(attribute, [ validator, o.first.to_s ].join('.'), { :count => count } )
            end
          end
        end
      end
      result
    end

    def full_messages_for(attribute)
      hints_for(attribute).map { |message| full_message(attribute, message) }
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

    # Do the hint messages include an hint with key +hint+?
    def include?(hint)
      (v = messages[hint]) && v.any?
    end
    alias :has_key? :include?

    # Get messages for +key+
    def get(key)
      messages[key]
    end

    # Set messages for +key+ to +value+
    def set(key, value)
      messages[key] = value
    end

    # Delete messages for +key+
    def delete(key)
      messages.delete(key)
    end

    # When passed a symbol or a name of a method, returns an array of hints
    # for the method.
    #
    #   p.hints[:name]   # => ["can not be nil"]
    #   p.hints['name']  # => ["can not be nil"]
    def [](attribute)
      get(attribute.to_sym) || set(attribute.to_sym, [])
    end

    # Adds to the supplied attribute the supplied hint message.
    #
    #   p.hints[:name] = "must be set"
    #   p.hints[:name] # => ['must be set']
    def []=(attribute, hint)
      self[attribute] << hint
    end

    # Iterates through each hint key, value pair in the hint messages hash.
    # Yields the attribute and the hint for that attribute. If the attribute
    # has more than one hint message, yields once for each hint message.
    #
    #   p.hints.add(:name, "can't be blank")
    #   p.hints.each do |attribute, hints_array|
    #     # Will yield :name and "can't be blank"
    #   end
    #
    #   p.hints.add(:name, "must be specified")
    #   p.hints.each do |attribute, hints_array|
    #     # Will yield :name and "can't be blank"
    #     # then yield :name and "must be specified"
    #   end
    def each
      messages.each_key do |attribute|
        self[attribute].each { |hint| yield attribute, hint }
      end
    end

    # Returns the number of error messages.
    #
    #   p.hints.add(:name, "can't be blank")
    #   p.hints.size # => 1
    #   p.hints.add(:name, "must be specified")
    #   p.hints.size # => 2
    def size
      values.flatten.size
    end

    # Returns all message values
    def values
      messages.values
    end

    # Returns all message keys
    def keys
      messages.keys
    end

    # Returns an array of hint messages, with the attribute name included
    #
    #   p.hints.add(:name, "can't be blank")
    #   p.hints.add(:name, "must be specified")
    #   p.hints.to_a # => ["name can't be blank", "name must be specified"]
    def to_a
      full_messages
    end

    # Returns the number of hint messages.
    #   p.hints.add(:name, "can't be blank")
    #   p.hints.count # => 1
    #   p.hints.add(:name, "must be specified")
    #   p.hints.count # => 2
    def count
      to_a.size
    end

    # Returns true if no hints are found, false otherwise.
    # If the hint message is a string it can be empty.
    def empty?
      all? { |k, v| v && v.empty? && !v.is_a?(String) }
    end
    alias_method :blank?, :empty?

    # Returns an xml formatted representation of the hints hash.
    #
    #   p.hints.add(:name, "can't be blank")
    #   p.hints.add(:name, "must be specified")
    #   p.hints.to_xml
    #   # =>
    #   #  <?xml version=\"1.0\" encoding=\"UTF-8\"?>
    #   #  <hints>
    #   #    <hint>name can't be blank</hint>
    #   #    <hint>name must be specified</hint>
    #   #  </hints>
    def to_xml(options={})
      to_a.to_xml options.reverse_merge(:root => "hints", :skip_types => true)
    end

    # Returns an ActiveSupport::OrderedHash that can be used as the JSON representation for this object.
    def as_json(options=nil)
      to_hash
    end

    def to_hash
      messages.dup
    end

    # Adds +message+ to the hint messages on +attribute+. More than one hint can be added to the same
    # +attribute+.
    # If no +message+ is supplied, <tt>:invalid</tt> is assumed.
    #
    # If +message+ is a symbol, it will be translated using the appropriate scope (see +translate_hint+).
    # If +message+ is a proc, it will be called, allowing for things like <tt>Time.now</tt> to be used within an hint.
    def add(attribute, message = nil, options = {})
      message = normalize_message(attribute, message, options)
      if options[:strict]
        raise ActiveModel::StrictValidationFailed, full_message(attribute, message)
      end

      self[attribute] << message
    end

    # Will add an hint message to each of the attributes in +attributes+ that is empty.
    def add_on_empty(attributes, options = {})
      [attributes].flatten.each do |attribute|
        value = @base.send(:read_attribute_for_validation, attribute)
        is_empty = value.respond_to?(:empty?) ? value.empty? : false
        add(attribute, :empty, options) if value.nil? || is_empty
      end
    end

    # Will add an hint message to each of the attributes in +attributes+ that is blank (using Object#blank?).
    def add_on_blank(attributes, options = {})
      [attributes].flatten.each do |attribute|
        value = @base.send(:read_attribute_for_validation, attribute)
        add(attribute, :blank, options) if value.blank?
      end
    end

    # Returns true if an hint on the attribute with the given message is present, false otherwise.
    # +message+ is treated the same as for +add+.
    #   p.hints.add :name, :blank
    #   p.hints.added? :name, :blank # => true
    def added?(attribute, message = nil, options = {})
      message = normalize_message(attribute, message, options)
      self[attribute].include? message
    end

    # Returns all the full hint messages in an array.
    #
    #   class Company
    #     validates_presence_of :name, :address, :email
    #     validates_length_of :name, :in => 5..30
    #   end
    #
    #   company = Company.create(:address => '123 First St.')
    #   company.hints.full_messages # =>
    #     ["Name is too short (minimum is 5 characters)", "Name can't be blank", "Email can't be blank"]
    def full_messages
      map { |attribute, message| full_message(attribute, message) }
    end

    # Returns a full message for a given attribute.
    #
    #   company.hints.full_message(:name, "is invalid")  # =>
    #     "Name is invalid"
    def full_message(attribute, message)
      return message if attribute == :base
      attr_name = attribute.to_s.gsub('.', '_').humanize
      attr_name = @base.class.human_attribute_name(attribute, :default => attr_name)
      I18n.t(:"hints.format", 
          :default   => "%{attribute} %{message}",
          :attribute => attr_name,
          :message   => message
          )
    end

    def generate_message(attribute, type, options = {})
      #options.delete(:message) if options[:message].is_a?(Symbol)
      if @base.class.respond_to?(:i18n_scope)
        defaults = @base.class.lookup_ancestors.map do |klass|
          [ :"#{@base.class.i18n_scope}.hints.models.#{klass.model_name.i18n_key}.attributes.#{attribute}.#{type}",
            :"#{@base.class.i18n_scope}.hints.models.#{klass.model_name.i18n_key}.#{type}" ]
        end
      else
        defaults = []
      end

      defaults << options[:message] # defaults << options.delete(:message)
      defaults << :"#{@base.class.i18n_scope}.hints.messages.#{type}" if @base.class.respond_to?(:i18n_scope)
      defaults << :"hints.attributes.#{attribute}.#{type}"
      defaults << :"hints.messages.#{type}"

      defaults.compact!
      defaults.flatten!

      key = defaults.shift

      options = {
        :default => defaults,
        :model => @base.class.model_name.human,
        :attribute => @base.class.human_attribute_name(attribute),
      }.merge(options)
      I18n.translate(key, 
                      :default => defaults,
                      :model => @base.class.model_name.human,
                      :attribute => @base.class.human_attribute_name(attribute),
                    )
    end

  end

end
