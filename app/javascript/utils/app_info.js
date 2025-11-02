// Example ES6 module demonstrating modern JavaScript features
// This showcases the importmap system working alongside Sprockets

/**
 * AppInfo - Utility class for application information
 * Demonstrates: ES6 classes, arrow functions, template literals, const/let
 */
class AppInfo {
  constructor() {
    this.name = "BrickEvent";
    this.version = "2.9";
    this.features = [
      "ES6 Modules via Importmap",
      "Sprockets for Active Scaffold",
      "Dart Sass for CSS",
      "Modern JavaScript"
    ];
  }

  /**
   * Get formatted version string
   * @returns {string}
   */
  getVersion() {
    return `${this.name} v${this.version}`;
  }

  /**
   * Log application info to console
   * Demonstrates: arrow functions, template literals, array methods
   */
  logInfo() {
    console.log(`🚀 ${this.getVersion()} - Modern JavaScript is running!`);
    console.log("📦 Features:");
    this.features.forEach(feature => console.log(`  ✓ ${feature}`));
  }

  /**
   * Check if modern JavaScript is supported
   * @returns {boolean}
   */
  isModernBrowser() {
    // Check for ES6 features
    try {
      // Arrow functions, const, template literals, classes
      new Function("const test = () => `modern`;");
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Export for use in other modules
export default AppInfo;
