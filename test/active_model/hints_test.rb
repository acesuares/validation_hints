# frozen_string_literal: true

require "test_helper"

class ActiveModelHintsTest < Minitest::Test
  def setup
    @person = Person.new
    @profile = Profile.new
  end

  def test_presence_hint
    assert_includes @person.hints[:name], "can't be blank"
  end

  def test_full_messages_for_includes_human_attribute_name
    messages = @person.hints.full_messages_for(:name)
    assert_equal ["Name can't be blank"], messages
  end

  def test_has_validations_for
    assert @person.has_validations_for?(:name)
    refute @person.has_validations_for?(:missing)
  end

  def test_has_validations_on_class_and_instance
    assert Person.has_validations?
    assert @person.has_validations?
  end

  def test_length_within_hint
    hints = @person.hints[:password]
    assert_includes hints, "must be between 1 and 4 characters"
  end

  def test_numericality_option_hints
    hints = @person.hints[:age]
    assert_includes hints, "must be an integer"
    assert_includes hints, "must be greater than 19"
  end

  def test_inclusion_hint_uses_list
    hints = @person.hints[:status]
    assert_equal 1, hints.size
    assert_match(/must be one of/, hints.first)
    assert_match(/active/, hints.first)
    assert_match(/inactive/, hints.first)
  end

  def test_virtual_attribute_with_validators_is_included
    assert_includes @profile.hints.keys, :nickname
    assert_includes @profile.hints[:nickname], "can't be blank"
  end

  def test_empty_returns_true_when_no_hint_messages
    person = Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations

      def self.name
        "EmptyModel"
      end
    end.new

    assert person.hints.empty?
  end

  def test_add_and_added_with_symbol_message
    person = Person.new
    person.hints.add(:name, :blank)
    assert person.hints.added?(:name, :blank)
  end

  def test_validator_keys_for_rails_7_validators
    validators = Person.validators_on(:name).map { |v| v.class.name.demodulize }
    assert_includes validators, "PresenceValidator"
  end
end
