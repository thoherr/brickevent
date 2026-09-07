# Implementation Plan: pretix Shop Integration for Attendees

Status: proposed (2026-09-07)
Related: `doc/plans/split-name-into-given-and-family-name.md` (PR #158)

## 1. Goal

Attendees order and pay event items (parking, event sets, shirts, catering,
tickets) in a pretix shop. BrickEvent identifies each attendee towards pretix
with a per-attendee voucher ("coupon"), shows the personal order link in the
attendance view, and later shows the resulting ticket (link to the pretix
ticket page and a QR code of the ticket secret) in the same place.

Integration is staged: CSV export/import first, pretix REST API later.

## 2. pretix shop setup (given)

- One pretix event per BrickEvent event.
- **One pretix product per event** (the "event product", e.g. "Teilnahme
  BB 2027"). Everything else (T-shirt, catering, event set, parking, ...) is
  configured as **add-on products** of that event product.
- One voucher per attendee, `max_usages = 1`, restricted to the event product,
  `show_hidden_items = true`; the event product is "hide without voucher" so
  it can only be bought through the personal link.
- Result in pretix: one order per attendee with one **main position** (the
  event product, carrying the voucher, the ticket secret and the position
  order link) plus zero or more **add-on positions** referencing the main
  position via "Add-on to position ID". The attendee does not see this
  structure, for them it is one order.

## 3. Workflow

```
BrickEvent                                   pretix
----------                                   ------
attendee created ──► coupon "ID-UUID"
attendee CSV export (incl. coupon) ────────► Create multiple vouchers (paste codes)
attendance view: order link per attendee ──► /redeem?voucher=CODE → event product + add-ons → order
                                             Export "Order data" (positions sheet)
order position import ◄──────────────────────── row with Voucher = main position:
                                                 Ticket secret, Position order link, Status
attendance view: ticket link + QR(secret)
```

## 4. Consistency check against pretix

Verified against the pretix API docs and the pretix source (master, 2026-09).

| # | Topic | Finding | Consequence for BrickEvent |
|---|---|---|---|
| 1 | Voucher code format | `code` is a CharField, max 255, min 5 characters, no character restriction. **pretix uppercases the code on save** and matches case-insensitively on redemption. Unique per pretix event (case-insensitive). | Generate the coupon in upper case (`"#{id}-#{SecureRandom.uuid.upcase}"`, 39 chars). Compare case-insensitively on import. Attendee id prefix guarantees uniqueness. |
| 2 | Redeem link | `https://<host>/<organizer>/<event>/redeem?voucher=<CODE>` (parameter name `voucher`). | Event needs a configurable shop base URL; BrickEvent builds the link. |
| 3 | Voucher and add-ons | The voucher is redeemed by the event product only; add-on positions do not consume voucher usages and carry no voucher in the export. With `max_usages = 1` exactly one main position per attendee exists. | The row with the voucher is the attendee's ticket. Add-on rows are identified by "Add-on to position ID" + order code if they are ever needed. |
| 4 | Voucher import | pretix has "Create multiple vouchers" (paste one code per line with shared settings) and the API endpoint `vouchers/batch_create`. There is no field-mapped CSV import. The bulk form rejects the whole batch if one code already exists. | Provide a plain code list export ("pretix voucher list") in addition to the coupon column in the attendee CSV. Track `coupon_exported_at` so the list can contain only new codes for incremental imports. |
| 5 | Order export | pretix "Order data" exporter, positions sheet. Relevant columns: Order code, Position ID, Status, Product, Variation, Attendee name, Attendee email, **Voucher**, Pseudonymization ID, **Ticket secret**, Add-on to position ID, **Position order link** (last column). **Headers and the Status text are localized** according to the pretix UI language at export time. | Export from pretix in English (fixed mapping), accept German header aliases as fallback. Map status text to a small enum. |
| 6 | Position order link | Points to the pretix **position page** `/ticket/<order>/<positionid>/<web_secret>/`, which shows the position with its add-ons and offers the PDF download. It is not the PDF itself. | Show it as "Ticket" link. The PDF URL could be derived (`.../download/<pid>/pdf`) but the page is the more robust target. |
| 7 | Cancelled and repeated orders | Cancelling an order releases the voucher, so an attendee can order again. The export then contains two rows with the same voucher (one canceled, one active). Orders can also be pending or expired. | Import keeps the non-canceled row (newest order date if several), stores the status, and shows the ticket only for paid orders. |
| 8 | QR code | pretix ticket QR codes contain exactly the position `secret`; pretixSCAN scans that string. | A QR code rendered from the secret is a valid substitute ticket. `rqrcode` is already a dependency. |
| 9 | Imported URLs | The ticket link comes from an uploaded file. | Validate on import that the URL starts with the event's shop base URL, otherwise reject the row (prevents injected links). |
| 10 | Existing `has_tickets` / `needs_ticket` | These flags describe LUG-issued tickets. | Keep them untouched. The new `show_order_link` is independent. Whether `needs_ticket` becomes obsolete for shop events is a later decision. |
| 11 | Personal data | The coupon contains only attendee id + random UUID. Order data (name, address, payment) is entered by the attendee in pretix. | No additional personal data leaves BrickEvent. Mention the shop in the privacy text. |
| 12 | API (stage 3) | Order positions can be listed per event with filters (`voucher`, `secret`, `search`, `item`, `order__status`); each position carries `downloads` (output + URL), `secret`, `voucher`, `addon_to`. Webhooks (`pretix.event.order.placed`, `paid`, changed, canceled, check-in) deliver only identifiers, the receiver must fetch details via API and be idempotent. | The attendee columns from stage 2 are directly reusable; the sync replaces the CSV round trip. |

Conclusion: with the event-product plus add-ons setup the proposed workflow
is consistent, and the ticket data can live directly on the attendee row.

## 5. Data model changes

### `attendees`
| Column | Type | Notes |
|---|---|---|
| `coupon_code` | string, unique index | `"#{id}-#{UUID}"` upper case, set `after_create`, backfilled by migration (stage 1) |
| `coupon_exported_at` | datetime, nullable | set by the voucher list export, enables incremental pretix import (stage 1) |
| `order_code` | string, nullable | pretix order code of the main position (stage 2) |
| `order_position_id` | integer, nullable | pretix position id of the main position (stage 2) |
| `order_status` | string, nullable | `pending`, `paid`, `expired`, `canceled` (stage 2) |
| `ticket_secret` | string, nullable | (stage 2) |
| `ticket_url` | string, nullable | "Position order link" (stage 2) |
| `order_imported_at` | datetime, nullable | (stage 2) |

### `events`
| Column | Type | Notes |
|---|---|---|
| `show_order_link` | boolean, default false | visibility switch for the order link (stage 1) |
| `shop_url` | string | pretix event base URL, e.g. `https://pretix.eu/bricking-bavaria/bb2027/`; validated with the existing url validator (stage 1) |

Stage 3 adds `pretix_organizer`, `pretix_event` slugs; the API token lives in
Rails credentials or ENV, not in the database.

Add-on positions are not stored in stage 1 and 2. If a list of ordered items
per attendee is wanted later, a small `shop_order_addons` table
(`attendee_id`, `order_code`, `position_id`, `product`, `variation`, `status`)
can be filled from the same import file (rows whose "Add-on to position ID"
equals the attendee's `order_position_id`) or from the API (`addon_to`).

## 6. Model behaviour

- `Attendee`
  - `after_create :generate_coupon_code` (uses `update_column`, needs the id)
  - `order_link` → `"#{event.shop_url}redeem?voucher=#{coupon_code}"` (nil if event has no `shop_url`)
  - `show_order_link?` → `event.show_order_link? && coupon_code.present? && is_approved? && !show_ticket?` (see §9 decisions 2 and 4)
  - `show_ticket?` → `ticket_secret.present? && order_status == 'paid'` (see §9 decision 3)
  - `order_pending?` → `order_status == 'pending'` (for a hint text)
  - CSV: new columns "Coupon" and "Bestell-Link", inserted before "Zuletzt geändert" so the last column stays stable (see §9 decision 5)
- `Event`
  - `vouchers_as_text(only_new: true)` → one coupon per line for pretix bulk creation, marks `coupon_exported_at`
  - `shop_configured?` → `shop_url.present?`

## 7. Stages

### Stage 1: coupon and order link (CSV export only)

1. Migration `AddCouponCodeToAttendees`: add `coupon_code`, `coupon_exported_at` + unique index, backfill all existing attendees (`"#{id}-#{UUID}"`, plain SQL loop like the name split).
2. Migration `AddShopFieldsToEvents`: `show_order_link`, `shop_url`.
3. `Attendee#generate_coupon_code` callback, `#order_link`, `#show_order_link?`; `Event#shop_configured?`.
4. Attendee CSV export: add "Coupon" and "Bestell-Link" columns (`Attendee.csv_array_header` / `#csv_array`). Update the two CSV tests (`test/models/event_test.rb`, `test/functional/events_controller_test.rb`).
5. New action `EventsController#vouchers_as_text` (POST, manager/admin only, like `attendees_as_csv`): returns `text/plain`, one coupon per line, parameter `all=1` to include already exported ones; sets `coupon_exported_at`. Button on `events/show.html.erb` next to the attendee CSV button, only when `shop_configured?`.
6. Attendance view: in `attendees/_table.html.erb` add a column "Shop" (header only when `event.shop_configured?`), cell shows `link_to t('order_link'), attendee.order_link, target: '_blank', rel: 'noopener'` when `attendee.show_order_link?`. Same column in `attendees/_exportlist.html.erb` for managers (shows the coupon code as text).
7. Admin: add `:show_order_link, :shop_url` to `Admin::EventsController` column list.
8. Locales: `heading_shop`, `order_link`, `export_pretix_vouchers`, hints; German and English.
9. Tests: coupon generation + format + uniqueness, backfill migration on sample data, `order_link` with and without `shop_url`, visibility helper, CSV columns, voucher list export incl. `coupon_exported_at` behaviour and authorization, view test that the link appears only when `show_order_link` is set.
10. Docs: CLAUDE.md feature flags, ROADMAP.md, short operator guide `doc/pretix.md` (pretix setup from §2, export in English).

### Stage 2: order import and ticket display

1. Migration `AddOrderFieldsToAttendees` (see §5).
2. Service `CsvOrderImport` (pattern of `CsvExhibitImport`):
   - CSV with `;` or `,` separator (pretix default is `,`; detect from header line), UTF-8 with BOM tolerated
   - header mapping English first, German aliases as fallback
   - skip rows with empty Voucher (add-on positions and orders without voucher); parse the attendee id prefix, load attendee, verify the full code case-insensitively and `attendee.event == event`, otherwise count as failure
   - validate `ticket_url` prefix against `event.shop_url`
   - several rows for one attendee (re-order after cancellation): prefer non-canceled, then newest order date
   - write `order_code`, `order_position_id`, `order_status`, `ticket_secret`, `ticket_url`, `order_imported_at`; re-import is idempotent
   - result hash like the exhibit import: success/failure/ignore counts, failed rows
3. `EventsController#order_import` (POST, multipart, managers/admins), form on `events/show.html.erb` below the exhibit import.
4. Attendance view: when `attendee.show_ticket?`, the "Shop" cell shows the ticket link (`ticket_url`, new tab) instead of the order link, plus the ticket secret as text and a "QR" link that opens a `<dialog>` with the QR code. QR rendered server-side with `RQRCode::QRCode.new(ticket_secret).as_svg` inline (no extra request, no external assets). A small importmap module `shop_ticket_dialog.js` handles open/close. When `order_pending?`, show a "payment pending" hint instead. Managers see the same in `attendees/_exportlist.html.erb`.
5. Tests: import service with fixture CSVs (valid, add-on rows ignored, foreign voucher, wrong event, bad URL, canceled + re-order, re-import idempotence), controller authorization, view rendering of link/secret/QR and the pending hint.

### Stage 3 (optional): pretix API

1. Config: `pretix_organizer`, `pretix_event` on events, API token per LUG in credentials.
2. `PretixClient` (Faraday or Net::HTTP) with pagination.
3. Voucher sync: `vouchers/batch_create` for attendees without `coupon_exported_at`, with the voucher settings from §2; replaces the paste step.
4. Order sync job: list `orderpositions` for the event, keep positions with a voucher, update the attendee columns; use `downloads` URL for the PDF when preferred. Triggered manually from the event page first, later scheduled.
5. Webhook endpoint (`POST /pretix/webhook`), idempotent, reacts to order placed/paid/changed/canceled by fetching the order and re-syncing its main position; disable CSRF for that route only.
6. Retire the CSV import UI once the sync is stable (keep the service for emergencies).

## 8. Security and privacy notes

- All new actions go through the existing `authorized?`/`is_managed_by?` checks; attendance view is already owner/manager/admin only.
- `coupon_code` is a bearer secret for the pretix shop: never show it on public pages, never log it.
- Imported `ticket_url` is validated against `shop_url`; `link_to` gets `rel="noopener"`.
- Run `rake security` after each stage (brakeman will flag the external `link_to` with dynamic URLs if the validation is missing).
- Privacy text: mention that ordering happens in the LUG's pretix shop.

## 9. Open decisions (defaults chosen, confirm or change)

| # | Question | Default |
|---|---|---|
| 1 | Coupon for every attendee, or only for events with `shop_url`? | Every attendee (cheap, avoids a second backfill later) |
| 2 | Show the order link only for approved attendees? | Yes, require `is_approved?` so unapproved registrations cannot buy the event product |
| 3 | Ticket shown for `paid` only, or also `pending`? | `paid` only; pending shows a "payment pending" hint |
| 4 | Once a ticket exists, hide the order link entirely (as proposed) or keep a small "order more" link? | Hide, as proposed; add-ons are ordered together with the event product |
| 5 | Where to place the coupon columns in the attendee CSV? | Before "Zuletzt geändert" |
| 6 | pretix export separator and language | Export in English; importer detects `,` vs `;` |
| 7 | Store add-on positions in BrickEvent? | Not in stage 1 and 2; optional `shop_order_addons` table later |
