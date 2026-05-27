# Changelog

All notable changes to this project are documented here.

## 8.1.9

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.9** (companion release for the dropdown_with_values double-translation fix, `money_field_show` always-show-cents fix, `FormElementShowcase` swap from `roles:info_list` to `locales:check_list + locales_display:info_list` with four seeded locales and populated file/audio/cover uploads, and the new locales-associations integration test; no API changes in validation_hints).

## 8.1.8

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.8** (companion release for re-introducing `money_field`, `scale_with_integers` and `scale_with_values` into the `FormElementShowcase` example resource, money-rails wired into the installer Gemfile, and a nil-guard on `money_field_show`; no API changes in validation_hints).

## 8.1.7

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.7** (companion release for three crashing `_show` helpers — `dropdown_with_integers`, `scale_with_integers`, `scale_with_values` — plus the `Versions (N)` header flicker fix and removal of debug `puts` statements in `month_year_picker_update`; no API changes in validation_hints).

## 8.1.6

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.6** (companion release for the `FormElementShowcase` example resource that exercises every kept Tier 1 form_element helper, plus the first field-level validation in the example app; no API changes in validation_hints).

## 8.1.5

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.5** (companion release for the hard-breaking `inline_forms_attribute_list` row-shape change in inline_forms; no API changes in validation_hints).

## 8.1.4

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.4** (companion release for the user-model search-scope fix and `MODEL_TABS` plumbing fix; no API changes in validation_hints).

## 8.1.3

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.3** (companion release; no API changes in validation_hints; lockstep bump for the PaperTrail 17.0 + `-U` collision-check release).

## 8.1.2

### Changed

- **Rails 8.1:** require **`activerecord` / `activemodel` `>= 8.1`, `< 8.2`** (was `>= 8.0, < 8.1`). Resolves Active Record / Active Model **8.1.x** in dev. No API changes; the `ActiveModel::Validations` patches and `ActiveModel::Hints` remain compatible.
- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.2** (companion release).

## 8.1.1

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.1** (companion release for `rails g inline_forms_addto`; no API changes in validation_hints).

## 8.1.0

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.1.0** (companion release; no API changes in validation_hints).

## 8.0.4

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.0.4** (companion release; no API changes in validation_hints).

## 8.0.3

### Added

- **Rails 8 release (Phase 5):** `stuff/rails-8-checklist.md` archived as complete; `stuff/analysis.md` and `stuff/roadmap.md` updated for 8.0.x stack.

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.0.3** (companion release; no API changes).

## 8.0.2

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.0.2** (companion release; no API changes).

## 8.0.1

### Changed

- **Active Record:** require **`>= 8.0`, `< 8.1`** (resolved **8.0.5** in dev). **inline_forms** must stay on validation_hints **8.0.1+** once it adopts Rails 8.
- **Dev:** `sqlite3` **`>= 2.1`** (Rails 8 sqlite3 adapter requirement).

### Fixed

- No code changes in `lib/active_model/hints.rb`; full suite and `stuff/smoke_test.sh` pass on AR 8.0.

## 8.0.0

### Fixed

- **`test/validation_hints_test.rb`:** version assert updated to **8.0.0**.

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **8.0.0** (opens the 8.x release line; **Rails / Active Record still 7.2.x** until the Rails 8 migration ships).

## 7.13.18

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.18** (companion release; no API changes).

## 7.13.17

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.17** (companion release; no API changes).

## 7.13.16

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.16** (companion release; no API changes).

## 7.13.15

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.15** (companion release; no API changes).

## 7.13.14

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.14** (companion release; no API changes).

## 7.13.13

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.13** (companion release; no API changes).

## 7.13.12

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.12** (companion release).
- **`Rakefile`:** `bundler/setup` is no longer loaded for `rake release` (fixes `Could not find sqlite3-…` when dev bundle was not installed). `rake test` runs `bundle install` if needed, then loads the bundle.

## 7.13.11

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.11** (companion release; no API changes).

## 7.13.10

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.10** (companion release; no API changes). Generated apps now pin `validation_hints '~> 7'` alongside `inline_forms '~> 7'`.

## 7.13.9

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.9** (companion release; no API changes in this gem). Catches up lockstep numbering after **7.13.4** while **inline_forms** / **inline_forms_installer** shipped **7.13.5**–**7.13.8**.

## 7.13.4

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.4** (companion release; no API changes in this gem). Pairs with the inline_forms rich_text-create Restore symmetry fix.

## 7.13.3

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.3** (companion release; no API changes in this gem). 7.13.2 is intentionally skipped to keep the three gems in lockstep after the inline_forms PaperTrail `:touch` / Restore-on-create fixes.

## 7.13.1

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.1** (companion release; no API changes in this gem).

## 7.13.0

### Changed

- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.13.0** (Track B companion release; no API changes in this gem).

### Verified

- **`bundle exec rake test`** — green on Rails 7.2 / Ruby 4.0.

## 7.12.0

### Changed

- **Rails 7.2:** runtime `activerecord` `>= 7.2.3.1`, `< 7.3` (was 7.1.x).
- **Ruby 4.0:** `required_ruby_version >= 4.0.0`.
- **Version numbering:** aligned with **inline_forms** / **inline_forms_installer** **7.12.0**.

### Verified

- **`bundle exec rake test`** — **24 runs, 50 assertions, 0 failures** on Rails 7.2 / Ruby 4.0.

## 7.0.0

### Changed

- **Major version bump.** Marks the Rails 7.1 line as stable (6.3.0 dropped Rails 7.0; 6.4.0 added format / custom / `validates_with` coverage). No API changes since 6.4.0.
- **Consumers:** `inline_forms` gemspec must widen its constraint to `>= 6.3, < 8.0` (or pin `~> 7.0`) to pick up this release.

## 6.4.0

### Added

- **Format validator hints:** `validates …, format: { with: … }` now emits `hints.messages.format` (was empty).
- **Custom EachValidator hints:** lookup via `hints.messages.<validator_key>` (e.g. `email_format`).
- **Tests:** format, custom EachValidator, `validates_with` class validator does not crash.

### Changed

- **`attribute_names_for_hints`:** skip validators without an `attributes` list (`validates_with` class validators).

### Added (docs)

- README: conditional validators, custom/`validates_with` validators, format I18n conventions.

## 6.3.0

### Changed

- **Rails 7.1:** runtime `activerecord` `>= 7.1.5`, `< 7.2` (was 7.0.x).
- **Dev deps:** dropped full `rails` gem; use `activerecord`, `activemodel`, `rake`, `sqlite3`, `minitest` only.

### Added

- **README:** security / `bundler-audit` section.

### Verified

- **`bundle exec rake test`** — **21 runs, 44 assertions, 0 failures** on Rails 7.1.

## 6.2.3

### Added

- **`stuff/smoke_test.sh`** — rake test + in-memory SQLite console smoke (`Widget.new.hints[:name]`).

### Changed

- **`stuff/analysis.md`** — updated for 6.2.x, inline_forms 7.9.x Tippy integration, API table.

## 6.2.2

### Added

- **Tests:** `confirmation` validator hint; custom `message:` as Symbol (with I18n override).
- **README:** inline_forms integration note; expanded `bundle exec rake test` instructions.

### Fixed

- **Custom `message:` Symbol:** strip `:message` from options before `generate_message` so lookup uses `presence.required` (not bare `required`).

## 6.2.1

### Fixed

- **`ActiveModel::Hints` and frozen validator options:** duplicate `validator.options` and `generate_message` options before mutation so Rails 7 frozen presence validators (`message: :required`) no longer raise `can't modify frozen Hash`.

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
