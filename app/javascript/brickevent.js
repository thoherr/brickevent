// Entry point for modern ES6 JavaScript loaded via importmap
// Configure your import map in config/importmap.rb
// (named brickevent.js, not application.js, because app/assets/javascripts/application.js
//  is the Sprockets bundle and would shadow this file in the asset load path)
// Read more: https://github.com/rails/importmap-rails
//
// Note: This app uses a hybrid JavaScript setup:
// - Sprockets: Active Scaffold + jQuery, only in the admin layout (app/assets/javascripts/application.js)
// - Importmap: Turbo, Stimulus and our ES6 modules on all other pages (this file)
//
// Add new JavaScript features here using ES6 import/export syntax

import "@hotwired/turbo-rails"
import "controllers"
import AppInfo from "utils/app_info";
import { initTicketDialogs } from "shop_ticket_dialog";

// A form re-rendered with validation errors inside a Turbo Frame keeps the
// scroll position of the submit button, so its error box may be out of view.
document.addEventListener("turbo:frame-render", (event) => {
  const errors = event.target.querySelector(".FormErrors");
  if (errors) errors.scrollIntoView({ block: "nearest" });
});

// turbo:load fires on the initial page load and after every Turbo visit,
// DOMContentLoaded only on the initial load.
document.addEventListener("turbo:load", () => {
  initTicketDialogs();

  const appInfo = new AppInfo();

  // Log app information to demonstrate ES6 modules are working
  // This just causes noise (e.g. when running tests) and should therefore only used when debugging
  // appInfo.logInfo();

  // Check browser compatibility
  if (!appInfo.isModernBrowser()) {
    console.warn("⚠️ This browser may not support all modern JavaScript features");
  }
});
