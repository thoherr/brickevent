# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mysql}
  s.version = "2.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["TOMITA Masahiro"]
  s.date = %q{2009-08-21}
  s.description = %q{This is the MySQL API module for Ruby. It provides the same functions for Ruby
programs that the MySQL C API provides for C programs.

This is a conversion of tmtm's original extension into a proper RubyGems.}
  s.email = ["tommy@tmtm.org"]
  s.extensions = ["ext/mysql_api/extconf.rb"]
  s.files = ["test/test_mysql.rb", "ext/mysql_api/extconf.rb"]
  s.homepage = %q{http://mysql-win.rubyforge.org}
  s.require_paths = ["lib", "ext"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{mysql-win}
  s.rubygems_version = %q{1.6.0}
  s.summary = %q{This is the MySQL API module for Ruby}
  s.test_files = ["test/test_mysql.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.5"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<rake-compiler>, ["~> 0.5"])
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<rake-compiler>, ["~> 0.5"])
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
