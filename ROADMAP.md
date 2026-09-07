# BrickEvent Roadmap

Living document of planned work beyond immediate bug fixes. Organized by theme, not strict priority — see the top of each section for sequencing notes.

## Status Snapshot (2026-04-09)

- Rails **8.1.1**, Ruby **3.3.5**, security audit **A+** (0 brakeman warnings, no CVEs)
- Test coverage **~95.6%**, 0 skipped tests
- `feature/ui-modernization` branch: Phase 1 complete (Hotwire + Avo + semantic HTML + mobile-first CSS), pending merge
- 11 open dependabot PRs — safe patch bumps ready to land

---

## 1. Dependencies & Security (immediate)

- [ ] Merge Rails 8.1.2.1 patch group (actionpack / actionview / activestorage / activesupport) as one update
- [ ] Merge minor bumps: nokogiri 1.19.1, action_text-trix 2.1.18
- [ ] Merge patch bumps: rack 3.2.5, bcrypt 3.1.22, json 2.15.2.1
- [ ] Re-run `rake security:check` after dependency updates
- [ ] Defer **devise 5.0.3** (major) — land after UI modernization to isolate testing scope
- [ ] Replace unmaintained **apparition** test driver with headless Chrome via Selenium/Cuprite

## 2. UI Modernization (active — `feature/ui-modernization`)

Phase 1 (done on branch): Hotwire installed, Active Scaffold → Avo, jQuery removed, semantic HTML, mobile viewport, backend search.

- [ ] Rebase branch onto updated master (post dependency merges)
- [ ] Full Avo CRUD smoke test across all 10 resources (accommodations, attendances, attendees, events, event_managers, exhibits, lugs, units, users, accommodation_types/attendee_types)
- [ ] Verify authorization rules for event managers in Avo (scope to their events only)
- [ ] Run full test + system suite, merge to master, tag **3.0**
- [ ] **One-page registration flow** — collapse multi-step attendee form into a single responsive view with Stimulus-driven conditional sections
- [ ] Mobile UX audit across public-facing views (registration, exhibits, voting)
- [ ] Turbo Frames for partial updates on exhibit listing & voting
- [ ] Toast notifications via Stimulus for flash messages

## 3. Asset Pipeline Simplification (post-merge)

Once Active Scaffold is gone, Sprockets has no remaining hard dependency.

- [ ] Migrate remaining SCSS from Sprockets to importmap / propshaft or cssbundling
- [ ] Remove Sprockets entirely, delete `app/assets/config/manifest.js`
- [ ] Audit and remove the demo `app_info.js` or repurpose it

## 4. Schema & Domain Cleanup

- [ ] **Exhibit size attributes**: resolve the `exhibits_controller.rb` FIXME — consolidate `size_studs` / `size` / `size_x_meter?` / `size_x_centimeter?` into a normalized size + unit pair, migrate data, drop dead columns
- [ ] Drop `events.lugname` column — use `lug_id` association exclusively
- [x] Split `users.name` / `attendees.name` into `given_name` + `family_name` (2026-09-06, see `doc/plans/split-name-into-given-and-family-name.md`)
- [ ] Review DB indexes added in #144 for any remaining N+1 / missing-index hotspots
- [ ] Document the "former exhibit" historical-tracking pattern in `ARCHITECTURE.md`, or simplify it

## 5. Domain Model Evolution

- [ ] **First-class MOCs**: extract MOCs from being attendance-scoped so they can be reused across events, with exhibit instances referencing a canonical MOC
- [ ] Revisit Attendance ↔ Exhibit relationship once MOCs are independent
- [ ] Generalize hardcoded texts and labels currently baked into views (see README TODO)

## 6. Internationalization

- [ ] Externalize event-level configurable labels (option_1, option_2, etc.) to I18n
- [ ] Translatable event descriptions & names
- [ ] Translatable user-generated content (exhibit/installation descriptions) — decide on per-locale storage strategy

## 7. Testing & Quality

- [ ] Replace apparition (see §1) and stabilize system test suite
- [ ] Add Avo system tests covering authorization scenarios per resource
- [ ] Expand integration coverage for voting workflow, CSV import, multi-event management

## 8. Observability & Performance

- [ ] Error tracking (Sentry or similar)
- [ ] APM / query analysis in production
- [ ] Caching strategy for hot read paths (event pages, exhibit listings, voting results)
- [ ] Load test voting under concurrent traffic (hundreds of simultaneous voters)

## 9. API & Integrations

- [x] pretix shop integration, stages 1+2: per-attendee vouchers, order link, CSV import of ticket data (2026-09-07, `doc/pretix.md`)
- [ ] pretix shop integration, stage 3: API sync of vouchers and orders, webhooks (`doc/plans/pretix-shop-integration.md`)
- [ ] Formalize JSON endpoints (JSON:API or similar) with OpenAPI docs
- [ ] Webhooks for event / attendance / voting lifecycle
- [ ] CSV import/export hardening (template validation, scheduled exports)

---

## Out of Scope / Deferred

- Rails 8.2 upgrade — not yet released; revisit when available
- Full SPA rewrite — Hotwire path is sufficient for current UX needs
- Multi-database / sharding — current scale doesn't warrant it
