# Changelog

All notable changes to this project are documented here.

## 6.0.0 (unreleased)

Modernize the gem for **Ruby 3.2+** and **Rails 7.0.x**, targeting use with **inline_forms 7.x**.

### Breaking changes

- Requires **Ruby >= 3.2** and **Active Record 7.0.x** (`>= 7.0`, `< 7.1`).
- Version jump from **0.2.x** to **6.0.0** signals a full modernization.
- Public API used by inline_forms is preserved: `hints`, `full_messages_for`, `has_validations?`, `has_validations_for?`.

### Added

- `ValidationHints::Railtie` — registers I18n and patches `ActiveModel::Validations` via `ActiveSupport.on_load(:active_model)` (Rails apps no longer need a manual `require`).
- `ValidationHints::ValidationsPatch` — extracted module for `has_validations*` and `hints`.
- `ValidationHints.load_i18n!` — idempotent locale registration.
- Runtime dependency on `activerecord` 7.0.x.
- Minitest harness (`test/`) and `rake test` as the default Rake task.
- `CHANGELOG.md`.

### Changed

- `ValidationHints::VERSION` set to `6.0.0`.
- Gemspec rewritten for current RubyGems / Bundler (Ruby version, dependencies, file list with non-git fallback).
- `Gemfile` source updated to `https://rubygems.org`.
- Entry point (`lib/validation_hints.rb`) refactored: Railtie in Rails, direct `active_model` load outside Rails.
- I18n locale registration moved behind `ValidationHints.load_i18n!` (was unconditional append at load time).

### Removed

- Obsolete development dependencies: jeweler, rcov, shoulda, rspec-rails, bundler ~> 1.0 pin.
- Inline `ActiveModel::Validations` patch from main entry file (moved to `validations_patch.rb`).

## 0.2.3

- Legacy release (Rails 3.2 era).
