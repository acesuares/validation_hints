module ActiveModel
  # == Active Model Hints
  #
  # more documentation needed

  class Errors
    include Enumerable

    def has_validations_for?(attribute)
      ! self.class.validators_on(attribute).empty?
    end

    def has_validations?(object, attribute)
      object.class.validators_on(attribute).empty? ? "" : 'has_validations '
    end

    def validation_help_as_list_for(object, attribute)
      has_validations?(object, attribute) ? content_tag(:ul, validation_help_for(object, attribute).map { |m| content_tag(:li, m ) }.join.html_safe )  : ""
    end

    # validation_help_for(object, attribute) extracts the help messages for
    # attribute of object.class (in an Array)
    def validation_help_for(object, attribute)
      object.class.validators_on(attribute).map do |v|
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
