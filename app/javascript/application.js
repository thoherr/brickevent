// Entry point for modern ES6 JavaScript loaded via importmap
// Configure your import map in config/importmap.rb
// Read more: https://github.com/rails/importmap-rails
//
// Note: This app uses a hybrid JavaScript setup:
// - Sprockets: Active Scaffold + jQuery (loaded via app/assets/javascripts/application.js)
// - Importmap: Modern ES6 modules (this file and future additions)
//
// Add new JavaScript features here using ES6 import/export syntax

// Example: Import and use an ES6 module
import AppInfo from "./utils/app_info";

// Initialize on DOM ready
document.addEventListener("DOMContentLoaded", () => {
  const appInfo = new AppInfo();

  // Log app information to demonstrate ES6 modules are working
  appInfo.logInfo();

  // Check browser compatibility
  if (!appInfo.isModernBrowser()) {
    console.warn("⚠️ This browser may not support all modern JavaScript features");
  }
});
