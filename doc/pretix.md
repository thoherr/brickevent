# pretix Shop Integration (Operator Guide)

BrickEvent hands every attendee a personal voucher code that is used as a
voucher in the LUG's pretix shop. Attendees order through a personal link,
and the resulting ticket can be imported back into BrickEvent.

Design and background: `doc/plans/pretix-shop-integration.md`.

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
| `shop_url` | pretix event URL from step 3 above. Enables the Shop column and the shop tools on the event page. |
| `show_order_link` | Shows the personal order link to approved attendees in the attendance view. Switch on once the vouchers are imported into pretix. |

## Workflow

1. **Export vouchers**: event page → "Neue Voucher für pretix exportieren".
   Downloads a CSV (ID, Vorname, Nachname, EMail, Voucher) and marks those
   attendees as exported, so the next export only contains new registrations.
   "Alle Voucher ..." exports everything again. The Voucher column is what
   gets pasted into pretix; the other columns identify the person.
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
5. Attendees with a **paid** order now see the ticket link and a QR code (the
   QR contains the ticket secret and is scannable with pretixSCAN). Admins and
   event managers additionally see the ticket secret as text. Pending orders show a hint, canceled or expired orders free
   the order link again.

## Import details

- Rows without a voucher (add-on positions, orders without voucher) are skipped.
- Rows whose voucher does not match an attendee of this event, whose status
  is unknown, or whose "Position order link" does not start with `shop_url`
  are reported as failed rows.
- If several rows exist for one attendee, the active (paid or pending) and
  newest row wins.
- The attendee CSV export contains the voucher, the order link and the imported order data (order code, position id, status, ticket secret, ticket link, import time) in the
  columns "Voucher", "Bestell-Link", "Bestellcode", "Positions-ID", "Bestellstatus", "Ticket-Secret", "Ticket-Link" and "Bestellung importiert".

## Security notes

- The voucher is a bearer secret for the shop: it is only shown to the
  attendance owner, event managers and admins.
- Imported ticket links are only accepted if they point into the configured
  shop.
