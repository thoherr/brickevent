// Opens and closes the <dialog> elements showing a ticket QR code.
// Markup: <a class="TicketQrLink" data-dialog="ID"> and <dialog id="ID"> with a <button class="TicketQrClose">.
export function initTicketDialogs(root = document) {
  root.querySelectorAll(".TicketQrLink").forEach((link) => {
    link.addEventListener("click", (event) => {
      event.preventDefault();
      const dialog = document.getElementById(link.dataset.dialog);
      if (dialog && typeof dialog.showModal === "function") {
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
