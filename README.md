# validation_hints

Proactive validation hints derived from model validators — complementary to Rails `errors` (which react after `valid?` fails).

**Requirements:** Ruby >= 4.0, Rails / Active Record **8.1.x** (`>= 8.1`, `< 8.2`). Used by [inline_forms](https://github.com/acesuares/inline_forms) 8.x for label tooltips on validated fields.

## Install

```ruby
# Gemfile
gem "validation_hints", "~> 8"
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

## Conditional validators

`:if`, `:unless`, and `:on` are **not evaluated** when building hints. Hints describe the static validation rules declared on the model, not whether they would run for the current record state. Use `errors` (after `valid?`) when you need conditional feedback.

## Custom validators

### `validates :attr, my_validator: true` (EachValidator)

The hint type is derived from the validator class name (`MyValidator` → `my`). Add copy under `hints.messages.my` or per-model/per-attribute keys in the lookup chain.

### `validates_with MyValidator` (class validator)

Only **EachValidator**-style validators (declared per attribute) produce hints automatically. Class-level `ActiveModel::Validator` implementations are not introspectable for attribute lists — prefer `validates :attr, …` or an EachValidator subclass when you need hint tooltips.

## Format validators

`validates :attr, format: { with: /…/ }` emits the default **`hints.messages.format`** copy (“must match the required format”). Override globally, per model, or per attribute via the I18n lookup chain; or set `message:` on the validator.

```yaml
en:
  activerecord:
    hints:
      models:
        person:
          attributes:
            code:
              format: "must be numeric"
```

## Security

Runtime dependency is **Active Record 7.2.x** only (no Action View / Active Storage in the gem).

Dev dependencies were slimmed from full `rails` to `activerecord` + `activemodel` to reduce audit noise. Run:

```bash
bundler-audit check --update
```

Rails **7.2.x** advisories: run `bundle exec bundler-audit` in your app; bump patch releases as needed.

## Tests

From the gem root:

```bash
bundle install
bundle exec rake test
```

Runs Minitest against an in-memory SQLite Active Record 7.2 app (`test/test_helper.rb`).

## History

See [CHANGELOG.md](CHANGELOG.md).
