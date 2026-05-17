# Changelog

All notable changes to this project are documented here.

## 6.2.0

I18n lookup chain and documentation (Phase 2).

### Added

- `activemodel.hints` and `activerecord.hints` locale scopes (format + lookup chain).
- `test/active_model/i18n_test.rb` — app override and `human_attribute_name` coverage.
- README: requirements, API, I18n lookup order, and `config/locales` override examples.

### Changed

- `generate_message` / `full_message` I18n fallback chain mirrors Rails errors (with `hints` namespace).
- `full_message` passes `base: @base` to `human_attribute_name` and resolves format via scoped `hints.format` keys.

## 6.1.0

Rails 7 compatibility for `ActiveModel::Hints` and expanded test coverage (Phase 1).

### Added

- `test/active_model/hints_test.rb` — presence, length, numericality, inclusion, virtual attributes, `empty?`, `add`/`added?`.
- In-memory SQLite ActiveRecord setup in `test/test_helper.rb`.
- `normalize_message` for mutable hint APIs (`add`, `added?`).
- `length.within` locale key with `%{minimum}` / `%{maximum}` interpolation.
- Default hint messages: `invalid`, `blank`, `empty`.

### Changed

- `ActiveModel::Hints` modernized for Rails 7:
  - plain `Hash` instead of `OrderedHash`
  - fixed `empty?` / `blank?`
  - `generate_message` aligned with Rails 7 I18n chain and interpolation
  - validator keys via `demodulize.underscore.delete_suffix("_validator")`
  - attribute discovery includes virtual attributes from validators
  - length min+max combined into a single `within` hint
  - presence hint suppressed when validator has `allow_blank: true`
- `locale/en.yml` cleaned up (removed stray keys; format copy → “must match the required format”).
- Documented behavior: conditional validators (`:if`, `:unless`, `:on`) are not evaluated.

## 6.0.0

Modernize the gem for **Ruby 3.2+** and **Rails 7.0.x**, targeting use with **inline_forms 7.x**.

### Breaking changes

- Requires **Ruby >= 3.2** and **Active Record 7.0.x** (`>= 7.0`, `< 7.1`).
- Version jump from **0.2.x** to **6.0.0** signals a full modernization.
- Public API used by inline_forms is preserved: `hints`, `full_messages_for`, `has_validations?`, `has_validations_for?`.

### Added

- `ValidationHints::Railtie` — registers I18n and patches `ActiveModel::Validations` via `ActiveSupport.on_load(:active_model)`.
- `ValidationHints::ValidationsPatch` — extracted module for `has_validations*` and `hints`.
- `ValidationHints.load_i18n!` — idempotent locale registration.
- Runtime dependency on `activerecord` 7.0.x.
- Minitest harness (`test/`) and `rake test` as the default Rake task.
- `CHANGELOG.md`.
- `rake release` / gem packaging tasks via `Bundler::GemHelper`.

### Changed

- Gemspec rewritten for current RubyGems / Bundler.
- `Gemfile` source updated to `https://rubygems.org`.
- Entry point refactored: Railtie in Rails, direct `active_model` load outside Rails.

### Removed

- Obsolete development dependencies: jeweler, rcov, shoulda, rspec-rails, bundler ~> 1.0 pin.
- Inline `ActiveModel::Validations` patch from main entry file (moved to `validations_patch.rb`).

## 0.2.3

- Legacy release (Rails 3.2 era).
