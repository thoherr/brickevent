# Implementation Plan: Inline Registration (Frontend Modernization Phase 2)

Status: implemented (2026-11-07)
Scope: the attendance page (`attendances#show`) and the attendee, MOC and
accommodation forms reached from it. Reduced version of "Phase 2" in
`modernization-recommendation.md`, see §2 for what is left out and why.

## 1. Goal

A registration can be completed on one page. Adding, editing and deleting
attendees, MOCs and accommodation requests happens in place on the attendance
page instead of on separate pages, without reloading the page. The existing
forms, validations and authorization stay as they are.

Today a typical registration (two people, three MOCs) takes about ten page
loads: every "Register person" / "Register MOC" / "Edit" opens a new page and
saving redirects back.

## 2. Decisions

| # | Topic | Decision |
|---|---|---|
| 1 | Progress bar ("60 % complete", "2 of 3 recommended") from the original plan | **Dropped.** An attendance has no draft or completion state and there are no recommended counts, so there is nothing to measure. Replaced by a status line with real data (§5.4). |
| 2 | Auto-save drafts, "Save draft" / "Complete registration" | **Dropped.** Every record is saved on submit; there is no draft to save. |
| 3 | Client-side validation with Stimulus | **Dropped.** It would duplicate the model validations in JavaScript. A failed save re-renders the form with errors (422, already the convention since Phase 1), inside the frame this happens in place. |
| 4 | Granularity of the Turbo Frames | **One frame per section** (attendees, MOCs, accommodation), not per row. The form replaces the section's table while it is open. Per-row frames would need `<turbo-frame>` inside `<tr>`, which is invalid HTML, so they only make sense together with a card layout (Phase 3). |
| 5 | Response after a successful save or delete from the attendance page | **Turbo Stream** that replaces the section, the status line and the flash messages. A plain redirect would refresh only the frame; the status line would stay stale and the notice would be lost. |
| 6 | Standalone new/edit pages | **Kept.** Event managers reach the edit pages from the event page (`*/_exportlist.html.erb`) and are sent back there via `redirect_back_or_default`. Non-frame requests keep exactly today's behaviour. |
| 7 | Tables vs. cards from the mockups | **Tables stay** in Phase 2. Cards and the mobile layout from `registration-flow-mockups.md` belong to Phase 3. |

## 3. How it works

```
attendances#show
 ├─ #attendance_status          status line (§5.4)
 ├─ #flashes                    flash messages (layout)
 ├─ <turbo-frame id="attendees">
 │    count line + "Register person" link + attendees table
 ├─ <turbo-frame id="exhibits">
 │    count line + "Register MOC" link + MOC table
 └─ <turbo-frame id="accommodations">   (only if event.has_accommodation)
      count line + "Add request" link + accommodation table
```

1. "Register person" / "Edit" links inside the frame load `attendees#new` /
   `#edit`. Those views wrap their form in `turbo_frame_tag "attendees"`, so
   Turbo swaps the table for the form. Opened directly (not in a frame), the
   same views render as full pages like today.
2. Submitting the form inside the frame sends the `Turbo-Frame: attendees`
   header.
   - Validation error: 422 with the form, rendered in the frame (as today).
   - Success: the controller sees `turbo_frame_request?` and answers with a
     Turbo Stream: replace the `attendees` frame, `#attendance_status` and
     `#flashes`.
   - No frame header (standalone page, e.g. from the event page): redirect
     as today.
3. "Delete" uses `turbo_method: :delete` inside the frame, gets the same
   Turbo Stream response.
4. A "Cancel" link in the form (only rendered for frame requests) reloads the
   section from the attendance page.

## 4. Inventory of affected code

### Views
| File | Change |
|---|---|
| `app/views/attendances/show.html.erb` | Split into section partials, add status line |
| `app/views/attendances/_attendees_section.html.erb` | **new**: frame, count line, add link, table |
| `app/views/attendances/_exhibits_section.html.erb` | **new**: incl. the former-MOC copy hint |
| `app/views/attendances/_accommodations_section.html.erb` | **new** |
| `app/views/attendances/_status.html.erb` | **new**: status line (§5.4) |
| `app/views/attendances/_section_update.turbo_stream.erb` | **new**: replaces section, status, flashes |
| `app/views/{attendees,exhibits,accommodations}/new.html.erb`, `edit.html.erb` | Wrap the form in the section frame |
| `app/views/{attendees,exhibits,accommodations}/_form.html.erb` | "Cancel" link for frame requests |
| `app/views/exhibits/_table.html.erb` | Links that leave the attendance (copy to another event, admin installation assignment) get `data-turbo-frame="_top"`; voting poster download already has `turbo: false` |
| `app/views/shared/_flashes.html.erb` | Wrap in `<div id="flashes">` so a stream can update it |

### Controllers
| File | Change |
|---|---|
| `app/controllers/concerns/attendance_section_response.rb` | **new**: `render_attendance_section(attendance, section)` renders the Turbo Stream with `flash.now` |
| `attendees_controller.rb`, `exhibits_controller.rb`, `accommodations_controller.rb` | In `create`, `update`, `destroy`: `if turbo_frame_request?` render the section stream, otherwise the existing redirect |

No changes to routes, models, strong parameters or authorization.

### Translations
The accommodation section and `AccommodationsController` have hard-coded German
texts ("Deine Übernachtungswünsche", "Weiteren Hotelwunsch eintragen", the three
notices). They move to `config/locales/application.{de,en}.yml` while the
section is rebuilt.

## 5. Implementation steps

### 5.1 Section partials (no behaviour change)
Move the three sections of `attendances/show.html.erb` into partials, each
wrapped in its `turbo_frame_tag`. Move `@registration_open` into a helper
(`registration_open?(attendance)`), because the partials are also rendered
from the Turbo Stream response, where `show` hasn't set the instance variable.
Run the existing tests; nothing visible changes yet.

### 5.2 Forms in the frame
Wrap `new`/`edit` of the three resources in the matching frame; add the cancel
link. Mark the links in the MOC table that must leave the frame with
`_top`. At this point editing already works inline; a successful save
refreshes only the frame (via the redirect).

### 5.3 Turbo Stream responses
Add the concern and the `turbo_frame_request?` branches. Wrap the flashes in
`#flashes`. Successful saves and deletes now update the section, status line
and notice together.

### 5.4 Status line
Above the sections, one line with data that exists:
- Registration confirmed: yes/no (`attendance.is_approved`)
- Attendees: confirmed / total
- MOCs: confirmed / total, plus a warning when MOCs have no size
  (`size_text_in_cm == 'MISSING'`, the table already marks these)
- Tickets: paid / total, only if `show_shop_columns?` applies

### 5.5 Accommodation translations
As listed in §4.

## 6. Tests

### Functional (`test/functional/*_controller_test.rb`)
For each of the three controllers:
- `create`/`update`/`destroy` with header `Turbo-Frame: <section>` respond
  with `text/vnd.turbo-stream.html` and replace the section frame.
- Without the header: redirect as before (existing tests).
- Failed save in a frame: 422 with the form inside the matching
  `<turbo-frame>`.

### System (`test/system/inline_registration_test.rb`, new)
- Add an attendee inline: form opens in place, URL stays the attendance page,
  after saving the table shows the attendee, count and status line update,
  notice is shown.
- Edit a MOC inline with an invalid URL: error shown in place; fix and save.
- Delete a MOC inline (confirm dialog), the section updates.
- Cancel closes the form without saving.
- Event manager edits an attendee from the event page: still a full page,
  saving returns to the event page.
- The existing delete test in `turbo_navigation_test.rb` keeps passing with the
  stream response (it expects to stay on the attendance page).

## 7. Out of scope (Phase 3 or later)
- Card layout and mobile views from `registration-flow-mockups.md`
- Per-row inline editing (needs cards, see decision 4)
- Loading indicators and transitions
- The event page for managers (`events#show`)

## 8. Effort
Roughly 20-25 hours, compared with 55 hours for the original Phase 2:
section partials and frames 6-8 h, stream responses 4-5 h, status line 2-3 h,
translations 1 h, tests 6-8 h.

## 9. Resolved questions
1. Status line: the four items in §5.4 are fine for now; to be checked
   against user feedback after the release.
2. Accommodation: rarely used in past events, but stays. It is built exactly
   like the other two sections: one "add" link in the count line (the second
   link below the table is dropped), translated texts, same table and
   actions as the others.
