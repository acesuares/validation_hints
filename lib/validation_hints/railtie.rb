# frozen_string_literal: true

module ValidationHints
  class Railtie < Rails::Railtie
    initializer "validation_hints.i18n" do
      ValidationHints.load_i18n!
    end

    ActiveSupport.on_load(:active_model) do
      ValidationHints::ValidationsPatch.apply!
    end
  end
end
