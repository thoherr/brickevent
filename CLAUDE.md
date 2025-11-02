# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BrickEvent is a Rails 7.2 web application for managing LEGO User Group (LUG) event registrations, exhibitor signups, and voting systems. Originally built for LEGO KidsFest 2012, it now supports multiple LUG events on a shared database with multi-tenant capabilities based on URL routing.

## Development Commands

### Setup
```bash
bundle install               # Install Ruby gems
rake db:migrate             # Run database migrations  
rake db:seed                # Seed database with initial data
```

### Development Server
```bash
bin/dev                     # Start server + CSS watcher (recommended)
bin/rails server            # Start development server only (alias: bin/rails s)
bin/rails console           # Start Rails console (alias: bin/rails c)
```

### Testing
```bash
rake test                   # Run all tests except system tests
bin/rails test:system       # Run system tests with Capybara
rake brakeman:check         # Run security analysis
```

### Asset Management
```bash
rake dartsass:build         # Build Sass CSS files
rake dartsass:watch         # Watch and rebuild CSS on file changes
rake assets:precompile      # Compile all assets for production
rake assets:clean           # Remove old compiled assets
rake assets:clobber         # Remove all compiled assets
```

### Database
```bash
rake db:create              # Create database
rake db:drop                # Drop database
rake db:reset               # Drop, create, and migrate database
```

## Core Domain Architecture

### Multi-Tenant Event Management
- **LUG (LEGO User Group)**: Top-level organization entity
- **Event**: Specific events managed by LUGs with configurable features
- **EventManager**: Join table linking users to events they can manage

### User & Registration System  
- **User**: Authentication via Devise with email confirmation
- **Attendee**: Person attending an event (linked to attendance)
- **AttendeeType**: Categories like exhibitor, visitor, staff
- **Attendance**: Join table linking attendees to events

### Exhibition System
- **Exhibit**: LEGO displays/MOCs with size tracking and voting
- **Unit**: Measurement units (studs, centimeters, etc.) with conversion factors
- **Accommodation**: Housing arrangements for attendees
- **AccommodationType**: Categories of accommodation

### Voting & Visitor System
- **Vote**: Uses acts_as_votable gem for exhibit voting
- **Visitor**: Non-registered users who can vote on exhibits
- **Voting scopes**: Configurable voting periods per event

### Key Model Relationships
- Events have many attendees through attendances
- Attendances link users to specific events with exhibits and accommodations
- Exhibits belong to attendances and can form installations (grouped exhibits)
- Former exhibit tracking allows historical connections between events

## Important Configuration

### Database Configuration
- Development/test: SQLite3
- Production: MySQL2
- Environment variables: `DATABASE_NAME`, `DATABASE_USERNAME`, `DATABASE_PASSWORD`

### Multi-tenancy
- LUG selection based on request URL/domain
- Logo URLs and branding configurable per LUG
- Event visibility controlled per LUG

### Key Features Flags
Events have boolean flags controlling features:
- `registration_open`: Allow new registrations
- `has_tickets`: Ticket system enabled  
- `has_moc_transport`: MOC transport coordination
- Various edit flags controlling what users can modify

## Testing Framework

Uses Rails minitest with:
- Model tests in `test/models/`
- Controller tests in `test/functional/` 
- System tests in `test/system/` using Capybara + Apparition
- SimpleCov for coverage reporting
- Fixtures in `test/fixtures/` for test data

## Services & Background Jobs

- **VotingPosterCreation**: Generates PDF voting posters for exhibits
- **VotingPosterZipfileCreation**: Creates zip files of voting materials  
- **CsvExhibitImport**: Bulk import exhibits from CSV
- **VotingResult**: Calculates and formats voting results

## Asset Pipeline

Modern asset pipeline using a hybrid approach:

### CSS Compilation
- **dartsass-rails**: Compiles application SCSS files to `app/assets/builds/`
  - `application.scss` → `application.css` (main styles)
  - `voting.scss` → `voting.css` (voting-specific styles)
  - Configured in `config/initializers/dartsass.rb`
- **Sprockets**: Serves compiled CSS and handles gem stylesheets
  - Active Scaffold CSS (has ERB dependencies, compiled via SassC)
  - Final asset serving from `public/assets/` in production

### JavaScript (Hybrid Approach)

**Two JavaScript systems work together:**

1. **Sprockets** (for Active Scaffold + jQuery)
   - Location: `app/assets/javascripts/application.js`
   - Uses `//= require` directives
   - Compiled by Sprockets (supports ERB)
   - Loaded via `javascript_include_tag "application"`
   - Includes: jQuery, jquery_ujs, Active Scaffold

2. **Importmap** (for modern ES6 modules)
   - Location: `app/javascript/application.js`
   - Uses ES6 `import`/`export` syntax
   - Configured in `config/importmap.rb`
   - Loaded via `javascript_importmap_tags`
   - No build step required

**Why hybrid?** Active Scaffold requires jQuery and uses ERB in its JavaScript files, which Sprockets handles. New application code should use modern ES6 modules via importmap.

- **Terser**: Modern JS minification for Sprockets assets

### Development Workflow
- Use `bin/dev` to start server with CSS file watcher
- CSS changes auto-rebuild via dartsass:watch
- No CoffeeScript (removed - was unused)
- Development/test: Assets compiled on-the-fly (`config.assets.compile = true`)

### Production Deployment
- Run `rake assets:precompile` before deployment
- Sprockets assets (CSS, Sprockets JS) are precompiled to `public/assets/`
- Importmap JavaScript files are served directly (no precompilation needed)
- Production settings:
  - `config.assets.compile = false` (no on-the-fly compilation)
  - `config.assets.css_compressor = :sass` (CSS minification)
- Web server (NGINX/Apache) serves precompiled assets from `public/assets/`