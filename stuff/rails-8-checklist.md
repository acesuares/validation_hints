# Rails 8 migration — checklist (archived)

**Status:** Migration **complete** on the **8.0.x** line (2026-05-22).

**Canonical runbook (maintainers):** `inline_forms/stuff/rails8forReal.md` (local copy; gitignored in inline_forms).

**Release summary (published docs):** [`inline_forms/docs/rails-8-release.md`](../../inline_forms/docs/rails-8-release.md)

**Zeitwerk / load paths:** [`inline_forms/docs/zeitwerk-and-load-paths.md`](../../inline_forms/docs/zeitwerk-and-load-paths.md)

| Gem | Released |
|-----|----------|
| **validation_hints** | **8.0.3** — AR `>= 8.0`, `< 8.1` |
| **inline_forms** | **8.0.3** — Rails `>= 8.0`, `< 8.1` |
| **inline_forms_installer** | **8.0.3** — lockstep |

**Example app gate:** `inline_forms create MyApp -d sqlite --example` → **88 runs, 502 assertions, 0 failures** (Rails 8.0.5).

For historical phase checklists, see git history of this file or `rails8forReal.md`.
