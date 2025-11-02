# frozen_string_literal: true

namespace :security do
  desc "Run bundler-audit to check for vulnerable dependencies"
  task :audit do
    require 'bundler/audit/cli'

    puts "Updating vulnerability database..."
    Bundler::Audit::CLI.start(['update'])

    puts "\nChecking for vulnerable dependencies..."
    Bundler::Audit::CLI.start(['check'])
  end

  desc "Run all security checks (bundler-audit + brakeman)"
  task :check => :environment do
    puts "=" * 80
    puts "Running Security Checks"
    puts "=" * 80

    # Run bundler-audit
    puts "\n1. Checking for vulnerable dependencies (bundler-audit)..."
    puts "-" * 80
    Rake::Task['security:audit'].invoke

    # Run brakeman
    puts "\n2. Running static security analysis (brakeman)..."
    puts "-" * 80
    Rake::Task['brakeman:check'].invoke

    puts "\n" + "=" * 80
    puts "Security checks completed!"
    puts "=" * 80
  end
end

# Alias for convenience
desc "Alias for security:check - runs all security checks"
task :security => 'security:check'
