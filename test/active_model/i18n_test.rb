# frozen_string_literal: true

require "test_helper"

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

    assert_equal ["needs a name"], @person.hints[:name]
  end

  def test_hints_attributes_override
    @kv.store_translations(:en, hints: { attributes: { name: { presence: "name hint" } } })

    assert_equal ["name hint"], @person.hints[:name]
  end

  def test_top_level_hints_messages_override
    @kv.store_translations(:en, hints: { messages: { presence: "fill this in" } })

    assert_includes @person.hints[:name], "fill this in"
  end

  def test_full_message_uses_activerecord_human_attribute_name
    @kv.store_translations(:en, activerecord: { attributes: { person: { name: "Your name" } } })

    assert_equal ["Your name can't be blank"], @person.hints.full_messages_for(:name)
  end

  def test_full_message_format_override
    @kv.store_translations(:en, activerecord: { hints: { format: "%{attribute}: %{message}" } })

    assert_equal ["Name: can't be blank"], @person.hints.full_messages_for(:name)
  end
end
