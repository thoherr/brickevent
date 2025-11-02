# Configure dartsass-rails to build multiple SCSS files
# See: https://github.com/rails/dartsass-rails

Rails.application.config.dartsass.builds = {
  "application.scss" => "application.css",
  "voting.scss" => "voting.css"
}
