
## Validation Hints

Delivers hints derived from the validation on a model.

### Install

```ruby
gem 'validation_hints'
```

### Example

```ruby
class Person < ActiveRecord::Base
  validates :name, :presence => true
  validates :password, :length => { :within => 1...5 }
end
```

```ruby
Person.new.hints[:name] => ["can't be blank"]
Person.new.hints[:password] => ["must not be shorter than 1 characters", "must not be longer than 4 characters"]
Person.new.hints.messages => {:id=>[], :password=>["must not be shorter than 1 characters", "must not be longer than 4 characters"], :name => ["can't be blank"] }
```

### Disclaimer

It's work in progress.
validation_hints was for the most part derived from activerecord-3.2.3/lib/active_record/errors.rb




