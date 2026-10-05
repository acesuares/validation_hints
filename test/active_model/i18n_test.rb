# frozen_string_literal: true

require "test_helper"

# `message: :required` is what every belongs_to declares (Rails adds
# validates_presence_of <assoc>, message: :required).
class RequiredCodePerson < ActiveRecord::Base
  self.table_name = "people"

  validates :code, presence: { message: :required }
end

class ActiveModelHintsI18nTest < Minitest::Test
  def setup
    @person = Person.new
    @backend = I18n.backend
    @kv = I18n::Backend::KeyValue.new({})
    I18n.backend = I18n::Backend::Chain.new(@kv, @backend)
  end

  def teardown
    I18n.backend = @backend
  end

  def test_activerecord_hints_messages_override
    @kv.store_translations(:en, activerecord: { hints: { messages: { presence: "is required" } } })

    assert_includes @person.hints[:name], "is required"
  end

  def test_activerecord_hints_model_attribute_override
    @kv.store_translations(
      :en,
      activerecord: {
        hints: {
          models: {
            person: {
              attributes: {
                name: { presence: "needs a name" }
              }
            }
          }
        }
      }
    )

    assert_equal [ "needs a name" ], @person.hints[:name]
  end

  def test_hints_attributes_override
    @kv.store_translations(:en, hints: { attributes: { name: { presence: "name hint" } } })

    assert_equal [ "name hint" ], @person.hints[:name]
  end

  def test_top_level_hints_messages_override
    @kv.store_translations(:en, hints: { messages: { presence: "fill this in" } })

    assert_includes @person.hints[:name], "fill this in"
  end

  # The en file had only a plain `presence` string, so "presence.required"
  # (every belongs_to hint) rendered "Translation missing" even in en.
  def test_required_message_resolves_in_en
    assert_equal [ "must be chosen" ], RequiredCodePerson.new.hints[:code]
  end

  def test_required_message_prefers_a_presence_required_key
    @kv.store_translations(:en, hints: { messages: { presence: { required: "pick one" } } })

    assert_equal [ "pick one" ], RequiredCodePerson.new.hints[:code]
  end

  def test_nl_ships_with_the_gem
    I18n.with_locale(:nl) do
      assert_includes @person.hints[:name], "moet ingevuld zijn"
      assert_equal [ "moet gekozen zijn" ], RequiredCodePerson.new.hints[:code]
      assert_equal [ "Name moet ingevuld zijn" ], @person.hints.full_messages_for(:name)
    end
  end

  def test_every_shipped_locale_has_the_keys_of_en
    flatten = lambda do |hash, prefix = nil|
      hash.flat_map { |key, value| value.is_a?(Hash) ? flatten.call(value, [ prefix, key ].compact.join(".")) : [ [ prefix, key ].compact.join(".") ] }
    end
    en_keys = flatten.call(YAML.load_file(ValidationHints::LOCALE_PATH)["en"]).sort
    assert_operator ValidationHints::LOCALE_PATHS.size, :>=, 2
    ValidationHints::LOCALE_PATHS.each do |path|
      locale, translations = YAML.load_file(path).first
      assert_equal en_keys, flatten.call(translations).sort, "#{locale} (#{File.basename(path)})"
    end
  end

  def test_full_message_uses_activerecord_human_attribute_name
    @kv.store_translations(:en, activerecord: { attributes: { person: { name: "Your name" } } })

    assert_equal [ "Your name can't be blank" ], @person.hints.full_messages_for(:name)
  end

  def test_full_message_format_override
    @kv.store_translations(:en, activerecord: { hints: { format: "%{attribute}: %{message}" } })

    assert_equal [ "Name: can't be blank" ], @person.hints.full_messages_for(:name)
  end
end
