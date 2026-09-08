// Entry point for the ES6 JavaScript loaded via importmap.
// Configure the import map in config/importmap.rb.
// (named brickevent.js instead of application.js so it can never be shadowed by a
//  Sprockets bundle of the same name in the asset load path)
// Read more: https://github.com/rails/importmap-rails

import "@hotwired/turbo-rails"
import "controllers"
import AppInfo from "utils/app_info";
import { initTicketDialogs } from "shop_ticket_dialog";

// turbo:load fires on the initial page load and after every Turbo navigation,
// DOMContentLoaded only on the initial load.
document.addEventListener("turbo:load", () => {
  initTicketDialogs();

  const appInfo = new AppInfo();

  // Log app information to demonstrate ES6 modules are working
  // This just causes noise (e.g. when running tests) and should therefore only used when debugging
  // appInfo.logInfo();

  if (!appInfo.isModernBrowser()) {
    console.warn("⚠️ This browser may not support all modern JavaScript features");
  }
});
