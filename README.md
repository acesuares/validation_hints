# validation_hints

Proactive validation hints derived from model validators — complementary to Rails `errors` (which react after `valid?` fails).

**Requirements:** Ruby >= 3.2, Rails / Active Record 7.0.x (`>= 7.0`, `< 7.1`). Used by [inline_forms](https://github.com/acesuares/inline_forms) 7.x for label tooltips on validated fields.

## Install

```ruby
# Gemfile
gem "validation_hints", "~> 6.2"
```

Rails apps load the gem via `ValidationHints::Railtie` (no manual `require`).

### inline_forms

Generated apps include `validation_hints` automatically. The engine patches load order so hints work when `rails/all` loads before Bundler. Tooltips use `has_validations_for?`, `hints.full_messages_for`, and Tippy.js in inline_forms 7.9.x — see inline_forms `CHANGELOG.md`.

## Example

```ruby
class Person < ApplicationRecord
  validates :name, presence: true
  validates :password, length: { within: 1...5 }
end

Person.new.hints[:name]      # => ["can't be blank"]
Person.new.hints[:password]  # => ["must be between 1 and 4 characters"]

Person.new.hints.full_messages_for(:name)  # => ["Name can't be blank"]
Person.new.has_validations_for?(:name)     # => true
```

## API (stable)

| Method | Description |
|--------|-------------|
| `model.hints` | `ActiveModel::Hints` for the instance |
| `hints[:attribute]` | Short hint strings for an attribute |
| `hints.full_messages_for(attr)` | Attribute label + hint (used by inline_forms tooltips) |
| `has_validations?` / `has_validations_for?(attr)` | Whether to show hint UI |

## I18n

Default copy lives in the gem at `lib/validation_hints/locale/en.yml` under the `hints` namespace.

Lookup order mirrors Rails **errors**, but uses **`hints`** instead of `errors`:

1. `activerecord.hints.models.<model>.attributes.<attr>.<type>`
2. `activerecord.hints.models.<model>.<type>`
3. `activerecord.hints.messages.<type>`
4. `activemodel.hints.messages.<type>`
5. `hints.attributes.<attr>.<type>`
6. `hints.messages.<type>`

Full messages (`full_messages_for`) use `hints.format` with the same scoping (`activerecord.hints.format`, `activemodel.hints.format`, `hints.format`).

### App overrides

Add a locale file, e.g. `config/locales/validation_hints.en.yml`:

```yaml
en:
  activerecord:
    hints:
      format: "%{attribute}: %{message}"
      messages:
        presence: "is required"
      models:
        apartment:
          attributes:
            name:
              presence: "enter a name for this apartment"
```

Per-attribute overrides without a model block:

```yaml
en:
  hints:
    attributes:
      name:
        presence: "is required"
```

Attribute labels in full messages come from the normal Rails path (`activerecord.attributes.<model>.<attr>`), same as errors.

## Tests

From the gem root:

```bash
bundle install
bundle exec rake test
```

Runs Minitest against an in-memory SQLite Active Record 7.0 app (`test/test_helper.rb`).

## History

See [CHANGELOG.md](CHANGELOG.md).
