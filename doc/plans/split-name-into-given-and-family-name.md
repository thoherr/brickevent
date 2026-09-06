# Implementation Plan: Split `name` into `given_name` and `family_name`

Status: implemented (2026-09-06)
Scope: `users` and `attendees` tables only. The `name` columns on `events`,
`exhibits`, `attendee_types`, `accommodation_types`, `units` and `lugs` are
not person names and stay untouched.

## 1. Goal

Replace the single free-text `name` column on `users` and `attendees` with two
columns, `given_name` and `family_name`, migrate existing data with a
best-effort split, and adapt every place that reads or writes a person's name:
system signup, profile editing, event registration (attendees), admin backend,
CSV export, and tests.

## 2. Inventory of affected code

Found by grepping for `name`, `user_name`, `.name` on user/attendee objects.

### Data model
| File | Current usage |
|---|---|
| `db/schema.rb` | `users.name`, `attendees.name` (both `string`) |
| `app/models/user.rb` | `validates_presence_of :email, :name` |
| `app/models/attendee.rb` | `to_s`, `csv_array_header` ("Name"), `csv_array` |
| `app/models/attendance.rb` | `user_name`, `to_s` use `user&.name` |
| `app/models/event_manager.rb` | `to_s` uses `user&.name` |
| `app/models/exhibit.rb` | `user_name` (delegates), CSV header "Name" + `csv_array` |
| `app/models/accommodation.rb` | `user_name` (delegates) |

### Controllers / strong params
| File | Current usage |
|---|---|
| `app/controllers/application_controller.rb:57` | Devise sign_up permits `:name` |
| `app/controllers/users_controller.rb:32` | `user_params` permits `:name` |
| `app/controllers/attendees_controller.rb:90` | `attendee_params` permits `:name` |
| `app/controllers/admin/users_controller.rb` | ActiveScaffold `update_columns` includes `:name` |
| `app/controllers/admin/attendees_controller.rb` | ActiveScaffold default columns (picks up schema automatically) |

### Views
| File | Current usage |
|---|---|
| `app/views/devise/registrations/new.html.erb` | `f.text_field :name` (system signup) |
| `app/views/devise/registrations/edit.html.erb` | check whether a name field exists |
| `app/views/users/_form.html.erb` | `f.text_field :name` (profile edit) |
| `app/views/attendees/_form.html.erb` | `f.text_field :name` (event registration) |
| `app/views/attendees/_table.html.erb` | `attendee.name` |
| `app/views/attendees/_exportlist.html.erb` | `attendee.name`, compares with `attendance.user.name` |
| `app/views/attendances/_exportlist.html.erb` | `user.name` |
| `app/views/attendances/show.html.erb` | `@attendance.user.name` |
| `app/views/exhibits/_table.html.erb`, `_exportlist.html.erb` | `a.user_name`, `exhibit.user_name` (indirect, no change if `user_name` keeps working) |
| `app/views/events/_vote_table.html.erb` | `exhibit.user_name` (indirect) |
| `app/views/accommodations/_exportlist.html.erb` | `accommodation.user_name` (indirect) |

### CSV
| File | Current usage |
|---|---|
| `app/models/attendee.rb` | export header "Name", value `name` |
| `app/models/exhibit.rb` | export header "Name" (builder), value `user_name` |
| `app/services/csv_exhibit_import.rb` | reads only `ID`, `Bestätigt`, `MOC`, `Tisch`, `Position`; the "Name" column is ignored. No functional change, but the header change must be verified against the import. |

### Locales
| File | Current usage |
|---|---|
| `config/locales/application.{de,en}.yml` | `label_name` ("Vollständiger Name" / "Full Name"), `heading_name` |
| `config/locales/de.yml:138` | `activerecord.errors.models.user.attributes.name.blank` |

### Tests
| File | Current usage |
|---|---|
| `test/fixtures/users.yml`, `test/fixtures/attendees.yml` | `name:` entries |
| `test/system/user_signup_test.rb` | `fill_in 'user_name'`, `User.create(:name => ...)` |
| `test/system/register_for_events_test.rb` | `User.create(:name => "Dummy User")` |
| `test/functional/users_controller_test.rb` | posts `name: ""` as invalid input |
| `test/models/attendance_test.rb` | `Attendee.create(:name => 'Marius')` |

## 3. Design decisions

1. **Column names**: `given_name` and `family_name` (`string`, nullable) on
   both tables. The old `name` column is dropped at the end of the migration
   (see §4). Rationale for dropping instead of keeping: a leftover `name`
   column would silently keep appearing in ActiveScaffold and would drift out
   of sync with the new fields.

2. **Shared behaviour in a concern** `app/models/concerns/person_name.rb`,
   included in `User` and `Attendee`:
   - `full_name` → `"#{given_name} #{family_name}".strip` (used everywhere a
     display name is needed)
   - `sortable_name` → `"#{family_name}, #{given_name}"` (for lists/CSV
     sorting; optional but cheap)
   - `PersonName.split(str)` → `[given, family]` (class-level helper used by
     the migration and unit-tested on its own)
   - No `name` alias is kept. Keeping `name` as a virtual method would hide
     leftover call sites and confuse ActiveScaffold; instead every call site is
     changed explicitly to `full_name`.

3. **Split rule** (`PersonName.split`):
   - blank → `[nil, nil]`
   - contains a comma → `"Family, Given"`: split at the first comma, strip
     both parts
   - otherwise split on whitespace: last token is `family_name`, everything
     before it is `given_name` (so "Anna Maria Müller" → "Anna Maria" /
     "Müller")
   - single token → `given_name` = token, `family_name` = nil
     (open decision, see §7)
   - No special handling for particles ("von", "van der"). The migration logs
     rows that are single-token or have four or more tokens so an admin can fix
     them in the backend afterwards.

4. **Validation**: `User` validates presence of `given_name` and `family_name`
   (replacing `validates_presence_of :name`). `Attendee` currently has no name
   validation; keep it that way (attendees may be unnamed guests) unless
   desired otherwise.

5. **`user_name` delegation methods** on `Attendance`, `Exhibit`,
   `Accommodation` keep their names and return `user&.full_name`. This keeps
   the exhibit/accommodation views and the exhibit CSV untouched.

6. **Screen tables** keep a single "Name" column showing `full_name`.
   **CSV exports** replace the single "Name" column with two columns
   "Vorname";"Nachname" (attendee export and exhibit export). This is the
   only externally visible format change; spreadsheet users must adapt.

## 4. Migration

`db/migrate/2026XXXXXXXXXX_split_name_into_given_and_family_name.rb`

```
up:
  add_column :users,     :given_name,  :string
  add_column :users,     :family_name, :string
  add_column :attendees, :given_name,  :string
  add_column :attendees, :family_name, :string
  for each table:
    select id, name via plain SQL (no AR models, to avoid validations)
    given, family = PersonName.split(name)
    update given_name/family_name with plain SQL, in batches
    say "ambiguous: #{table} ##{id} '#{name}'" for single-token / 4+ token rows
  remove_column :users,     :name
  remove_column :attendees, :name

down:
  add_column :name back on both tables
  fill name = [given_name, family_name].compact.join(' ') via SQL
  remove given_name / family_name
```

Notes:
- Works on SQLite (dev/test) and MySQL (production); only standard SQL.
- The split helper must be loadable inside the migration; either require
  `app/models/concerns/person_name.rb` explicitly or place the pure split
  logic in `lib/person_name_splitter.rb` and have the concern delegate to it.
- Optional: `add_index :users, :family_name` / `:attendees, :family_name` if
  sorting by family name is introduced in lists.
- Before running in production: take a DB backup; afterwards review the
  "ambiguous" log lines in the admin backend.

## 5. Step-by-step implementation

1. **Split helper + concern**
   - `lib/person_name_splitter.rb` with `.split(str)` and the rules from §3.3
   - `app/models/concerns/person_name.rb` with `full_name`, `sortable_name`,
     includes the splitter
   - Unit tests: `test/lib/person_name_splitter_test.rb` covering blank,
     "Given Family", "Family, Given", multi-token given names, single token,
     surrounding whitespace, comma with extra spaces.

2. **Migration** as in §4, plus `db/schema.rb` regeneration.

3. **Models**
   - `User`: include concern, `validates_presence_of :given_name, :family_name`
   - `Attendee`: include concern, `to_s` → `"#{full_name} (#{attendee_type})"`,
     CSV header "Name" → "Vorname","Nachname"; `csv_array` emits both
   - `Attendance#user_name`, `Attendance#to_s`, `EventManager#to_s` →
     `user&.full_name`
   - `Exhibit.csv_array_header`: "Name" → "Vorname","Nachname";
     `csv_array` → `user_given_name`, `user_family_name` (new delegations on
     `Attendance`/`Exhibit`) or keep a single `user_name` column (decide, §7)

4. **Strong params / admin**
   - `application_controller.rb` Devise sign_up keys: `:given_name, :family_name`
   - `users_controller.rb#user_params`, `attendees_controller.rb#attendee_params`
   - `admin/users_controller.rb` update_columns: replace `:name`
   - `admin/attendees_controller.rb`: nothing needed (default columns), but
     verify list order/labels in the backend

5. **Views**
   - Signup (`devise/registrations/new`), profile (`users/_form`), attendee
     form (`attendees/_form`): two text fields with new labels; check
     `devise/registrations/edit` as well
   - `attendees/_table`, `attendees/_exportlist`, `attendances/_exportlist`,
     `attendances/show`: use `full_name`; in `attendees/_exportlist` compare
     `attendee.full_name` with `attendee.attendance.user.full_name`

6. **Locales** (`application.de.yml`, `application.en.yml`, `de.yml`, `en.yml`)
   - add `label_given_name` ("Vorname" / "Given name"),
     `label_family_name` ("Nachname" / "Family name"),
     optional `heading_given_name` / `heading_family_name`
   - `activerecord.errors.models.user.attributes.given_name.blank` and
     `.family_name.blank` replacing the `name.blank` message
   - optional `activerecord.attributes.user.given_name` etc. so ActiveScaffold
     shows translated column headers
   - remove `label_name` only if no other view still uses it (grep first)

7. **Tests**
   - Fixtures: `users.yml`, `attendees.yml` → `given_name`/`family_name`
   - `user_signup_test.rb`: `fill_in 'user_given_name'` /
     `'user_family_name'`; `User.create(...)` calls
   - `register_for_events_test.rb`, `attendance_test.rb`: `create` calls
   - `users_controller_test.rb`: invalid params use the new fields
   - New: model test for `User#full_name`, `Attendee#to_s`, validation of both
     name parts; CSV export test asserting the new header columns
     (`Event#attendees_as_csv`, `Event#exhibits_as_csv`)
   - `csv_exhibit_import_test.rb`: unchanged (import ignores name columns);
     optionally extend the fixture CSVs with the new header columns to mirror
     real exports

8. **Docs / housekeeping**
   - `CLAUDE.md` domain section: mention `given_name`/`family_name`
   - `ROADMAP.md` §4 "Schema & Domain Cleanup": add/check off the item
   - `RELEASE` / changelog entry noting the CSV format change

9. **Verification**
   - `rake db:migrate` on a copy of production data (or seeded dev DB) and
     inspect the ambiguous-rows log
   - `rake test`, `bin/rails test:system`
   - `rake security` (brakeman should stay at 0 warnings)
   - Manual smoke test: signup, profile edit, add attendee, admin backend edit,
     both CSV downloads open correctly in a spreadsheet

## 6. Rollout

1. Merge behind a normal PR; the migration is reversible.
2. Production: backup DB → `bundle exec rake db:migrate` → review migration log
   → spot-check a few users/attendees in the admin backend.
3. Inform event managers that the CSV exports now have "Vorname"/"Nachname"
   columns instead of "Name".

## 7. Open decisions (defaults chosen, confirm or change)

| # | Question | Default in this plan |
|---|---|---|
| 1 | Single-token names ("Marius"): given or family name? | `given_name` |
| 2 | Drop the old `name` column in the same migration, or keep it read-only for one release? | Drop in the same migration (reversible) |
| 3 | Exhibit CSV: two builder columns or one combined column? | Two columns, consistent with attendee export |
| 4 | Require both name parts for `Attendee` as well? | No, keep attendees unvalidated |
| 5 | Sort attendee/attendance lists by family name instead of id? | Not in this change; possible follow-up |
