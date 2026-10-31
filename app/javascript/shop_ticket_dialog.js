// Opens and closes the <dialog> elements showing a ticket QR code.
// Markup: <a class="TicketQrLink" data-dialog="ID"> and <dialog id="ID"> with a <button class="TicketQrClose">.
// The QR code image is only fetched when its dialog opens for the first time:
// <img class="TicketQrImage" data-src="URL"> gets its src set then.
export function initTicketDialogs(root = document) {
  root.querySelectorAll(".TicketQrLink").forEach((link) => {
    link.addEventListener("click", (event) => {
      event.preventDefault();
      const dialog = document.getElementById(link.dataset.dialog);
      if (dialog && typeof dialog.showModal === "function") {
        dialog.querySelectorAll("img.TicketQrImage[data-src]").forEach((img) => {
          if (!img.getAttribute("src")) img.src = img.dataset.src;
        });
        dialog.showModal();
      }
    });
  });

  root.querySelectorAll(".TicketQrDialog").forEach((dialog) => {
    dialog.querySelectorAll(".TicketQrClose").forEach((button) => {
      button.addEventListener("click", () => dialog.close());
    });
    // click on the backdrop closes the dialog
    dialog.addEventListener("click", (event) => {
      if (event.target === dialog) dialog.close();
    });
  });
}
