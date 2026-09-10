# pretix Shop Integration (Operator Guide)

BrickEvent hands every attendee a personal voucher code that is used as a
voucher in the LUG's pretix shop. Attendees order through a personal link,
and the resulting ticket can be imported back into BrickEvent.

Design and background: `doc/plans/pretix-shop-integration.md`.

## Vouchers

Every attendee gets a voucher code (`<attendee id>-<UUID>`) automatically
when the attendee record is created, no matter whether the event uses the
shop. Attendees that existed before the shop integration were given
vouchers by the database migration. Nothing has to be activated for that,
so the vouchers can be imported into pretix before the shop is switched on
for the attendees.

## pretix setup per event

1. Create the pretix event and **one product** for the event ("event
   product", e.g. "Teilnahme BB 2027"). Configure T-shirts, catering, event
   sets, parking etc. as **add-on products** of that product.
2. Set the event product to "hide without voucher" so it can only be bought
   through the personal links.
3. Note the shop URL of the event, e.g. `https://pretix.eu/<organizer>/<event>/`.

## BrickEvent setup per event (admin backend)

| Field | Meaning |
|---|---|
| `shop_url` | pretix event URL from step 3 above. Enables the shop tools (voucher export, order import) on the event page for managers. |
| `show_order_link` | Shows the personal order link to approved attendees. Switch on once the vouchers are imported into pretix. |

## Workflow

1. **Export vouchers**: event page → "Neue Voucher für pretix exportieren".
   Downloads a CSV (ID, Vorname, Nachname, EMail, Voucher) and marks those
   attendees as exported, so the next export only contains new registrations.
   "Alle Voucher ..." exports everything again (and marks them as well). The
   Voucher column is what gets pasted into pretix; the other columns identify
   the person.
2. **Create vouchers in pretix**: Vouchers → "Create multiple vouchers",
   paste the codes. Settings: product = event product, maximum usages = 1,
   "allow to buy hidden products" = yes. Repeat for each incremental export.
3. **Switch on `show_order_link`**. Approved attendees now see "Bestellen" in
   the Shop column of their attendance page. The link opens
   `<shop_url>redeem?voucher=<voucher>` in pretix.
4. **Import orders**: in pretix export "Order data" as CSV, sheet
   "Positions", **with the pretix UI set to English** (headers and status
   texts are localized). Upload it on the event page ("pretix-Bestellungen
   importieren"). Repeat as often as needed; the import is idempotent.
5. Attendees with a **paid** order now see "Bestellbestätigung" and
   "Abhol-Code" (see below). Pending orders show a hint, canceled or expired
   orders free the order link again.

## The Shop and Abhol-Code columns

The attendee tables (attendance page and event page) have two shop related
columns. They are rendered only while the shop is enabled for the event
(`shop_url` set **and** `show_order_link` on) or when at least one attendee
in the table already has an imported order, so the columns are never empty
and imported tickets stay visible after the order phase.

| Column | Content | Visible to |
|---|---|---|
| Shop | "Bestellen" (personal order link) while no active order exists; "Bestellung offen (Zahlung ausstehend)" for a pending order; "Bestellbestätigung" (link to the pretix ticket page with the PDF) for a paid order | everyone who can open the page |
| Shop | the voucher code as small text below | admins and event managers (event page only) |
| Abhol-Code | link opening a dialog with the QR code of the ticket secret, scannable with pretixSCAN when the exhibitor package is collected at the venue | everyone who can open the page, paid orders only |
| Abhol-Code | the ticket secret as text, in the cell and inside the dialog | admins and event managers |

Not related to the shop: the column "Ticket" in the attendee data is the
attendee's own "needs an entrance ticket" answer from the registration form.

## Import details

- Rows without a voucher (add-on positions, orders without voucher) are skipped.
- Rows whose voucher does not match an attendee of this event, whose status
  is unknown, or whose "Position order link" does not start with `shop_url`
  are reported as failed rows.
- If several rows exist for one attendee, the active (paid or pending) and
  newest row wins.
- The **attendee data import** (CSV with the attendee export columns, on the
  event page) deliberately ignores the voucher and order columns, so a round
  trip export → edit → import cannot change shop data.

## Exports

- The attendee CSV export contains the voucher, the order link and the
  imported order data in the columns "Voucher", "Bestell-Link", "Bestellcode",
  "Positions-ID", "Bestellstatus", "Ticket-Secret", "Ticket-Link" and
  "Bestellung importiert".
- All CSV exports are ISO-8859-15 encoded. Characters outside that encoding
  are transliterated ("ł" → "l"); characters without an equivalent appear as
  "?". Correct such names in the backend or via the attendee data import.

## Security notes

- The voucher is a bearer secret for the shop: it is only shown to the
  attendance owner, event managers and admins.
- Imported ticket links are only accepted if they point into the configured
  shop.
