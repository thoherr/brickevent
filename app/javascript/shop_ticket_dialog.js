// Opens and closes the <dialog> elements showing a ticket QR code.
// Markup: <a class="TicketQrLink" data-dialog="ID"> and <dialog id="ID"> with a <button class="TicketQrClose">.
// The QR code image is only fetched when its dialog opens for the first time:
// <img class="TicketQrImage" data-src="URL"> gets its src set then.
//
// The listener is delegated from the document, so it also covers tables that
// Turbo Frames and Turbo Streams replace (the sections of the attendance page).
function handleClick(event) {
  const link = event.target.closest(".TicketQrLink");
  if (link) {
    event.preventDefault();
    const dialog = document.getElementById(link.dataset.dialog);
    if (dialog && typeof dialog.showModal === "function") {
      dialog.querySelectorAll("img.TicketQrImage[data-src]").forEach((img) => {
        if (!img.getAttribute("src")) img.src = img.dataset.src;
      });
      dialog.showModal();
    }
    return;
  }

  const dialog = event.target.closest(".TicketQrDialog");
  if (!dialog) return;
  // the close button, or a click on the backdrop (the dialog element itself)
  if (event.target.closest(".TicketQrClose") || event.target === dialog) dialog.close();
}

let initialized = false;

export function initTicketDialogs() {
  if (initialized) return;
  document.addEventListener("click", handleClick);
  initialized = true;
}
