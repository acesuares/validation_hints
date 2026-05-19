# frozen_string_literal: true

require "bundler/setup"
require "minitest/autorun"
require "active_record"
require "active_model"

require "validation_hints"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table :people, force: true do |t|
    t.string :name
    t.string :password
    t.string :password_confirmation
    t.integer :age
    t.string :status
    t.string :email
    t.string :code
  end
end

class Person < ActiveRecord::Base
  validates :name, presence: true
  validates :password, length: { within: 1...5 }
  validates :age, numericality: { only_integer: true, greater_than: 19 }
  validates :status, inclusion: { in: %w[active inactive] }
  validates :password, confirmation: true
  validates :email, presence: { message: :required }
  validates :code, format: { with: /\A\d+\z/ }
end

class EmailFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless value.to_s.include?("@")
  end
end

class CodePresenceValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add(:code, :blank) if record.code.blank?
  end
end

class CustomValidatorPerson < ActiveRecord::Base
  self.table_name = "people"

  validates :email, email_format: true
  validates_with CodePresenceValidator
end

class Profile < ActiveRecord::Base
  self.table_name = "people"

  attr_accessor :nickname

  validates :nickname, presence: true
end
