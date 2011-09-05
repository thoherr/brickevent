# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{johnson}
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Barnette", "Aaron Patterson", "Yehuda Katz", "Matthew Draper"]
  s.date = %q{2010-01-25}
  s.default_executable = %q{johnson}
  s.description = %q{Johnson wraps JavaScript in a loving Ruby embrace. It embeds the
Mozilla SpiderMonkey JavaScript runtime as a C extension.}
  s.email = ["jbarnette@rubyforge.org", "aaron.patterson@gmail.com", "wycats@gmail.com", "matthew@trebex.net"]
  s.executables = ["johnson"]
  s.extensions = ["ext/spidermonkey/extconf.rb"]
  s.files = ["test/johnson/browser_test.rb", "test/johnson/conversions/array_test.rb", "test/johnson/conversions/boolean_test.rb", "test/johnson/conversions/callable_test.rb", "test/johnson/conversions/file_test.rb", "test/johnson/conversions/nil_test.rb", "test/johnson/conversions/number_test.rb", "test/johnson/conversions/regexp_test.rb", "test/johnson/conversions/string_test.rb", "test/johnson/conversions/struct_test.rb", "test/johnson/conversions/symbol_test.rb", "test/johnson/conversions/thread_test.rb", "test/johnson/custom_conversions_test.rb", "test/johnson/error_test.rb", "test/johnson/extensions_test.rb", "test/johnson/nodes/array_literal_test.rb", "test/johnson/nodes/array_node_test.rb", "test/johnson/nodes/binary_node_test.rb", "test/johnson/nodes/bracket_access_test.rb", "test/johnson/nodes/delete_test.rb", "test/johnson/nodes/do_while_test.rb", "test/johnson/nodes/dot_accessor_test.rb", "test/johnson/nodes/export_test.rb", "test/johnson/nodes/for_test.rb", "test/johnson/nodes/function_test.rb", "test/johnson/nodes/if_test.rb", "test/johnson/nodes/import_test.rb", "test/johnson/nodes/label_test.rb", "test/johnson/nodes/let_test.rb", "test/johnson/nodes/object_literal_test.rb", "test/johnson/nodes/return_test.rb", "test/johnson/nodes/semi_test.rb", "test/johnson/nodes/switch_test.rb", "test/johnson/nodes/ternary_test.rb", "test/johnson/nodes/throw_test.rb", "test/johnson/nodes/try_node_test.rb", "test/johnson/nodes/typeof_test.rb", "test/johnson/nodes/unary_node_test.rb", "test/johnson/nodes/void_test.rb", "test/johnson/nodes/while_test.rb", "test/johnson/nodes/with_test.rb", "test/johnson/prelude_test.rb", "test/johnson/runtime_test.rb", "test/johnson/spidermonkey/context_test.rb", "test/johnson/spidermonkey/immutable_node_test.rb", "test/johnson/spidermonkey/js_land_proxy_test.rb", "test/johnson/spidermonkey/ruby_land_proxy_test.rb", "test/johnson/spidermonkey/runtime_test.rb", "test/johnson/version_test.rb", "test/johnson/visitors/dot_visitor_test.rb", "test/johnson/visitors/enumerating_visitor_test.rb", "test/johnson_test.rb", "test/parser_test.rb", "bin/johnson", "ext/spidermonkey/extconf.rb"]
  s.homepage = %q{http://github.com/jbarnette/johnson}
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = %q{johnson}
  s.rubygems_version = %q{1.6.0}
  s.summary = %q{Johnson wraps JavaScript in a loving Ruby embrace}
  s.test_files = ["test/johnson/browser_test.rb", "test/johnson/conversions/array_test.rb", "test/johnson/conversions/boolean_test.rb", "test/johnson/conversions/callable_test.rb", "test/johnson/conversions/file_test.rb", "test/johnson/conversions/nil_test.rb", "test/johnson/conversions/number_test.rb", "test/johnson/conversions/regexp_test.rb", "test/johnson/conversions/string_test.rb", "test/johnson/conversions/struct_test.rb", "test/johnson/conversions/symbol_test.rb", "test/johnson/conversions/thread_test.rb", "test/johnson/custom_conversions_test.rb", "test/johnson/error_test.rb", "test/johnson/extensions_test.rb", "test/johnson/nodes/array_literal_test.rb", "test/johnson/nodes/array_node_test.rb", "test/johnson/nodes/binary_node_test.rb", "test/johnson/nodes/bracket_access_test.rb", "test/johnson/nodes/delete_test.rb", "test/johnson/nodes/do_while_test.rb", "test/johnson/nodes/dot_accessor_test.rb", "test/johnson/nodes/export_test.rb", "test/johnson/nodes/for_test.rb", "test/johnson/nodes/function_test.rb", "test/johnson/nodes/if_test.rb", "test/johnson/nodes/import_test.rb", "test/johnson/nodes/label_test.rb", "test/johnson/nodes/let_test.rb", "test/johnson/nodes/object_literal_test.rb", "test/johnson/nodes/return_test.rb", "test/johnson/nodes/semi_test.rb", "test/johnson/nodes/switch_test.rb", "test/johnson/nodes/ternary_test.rb", "test/johnson/nodes/throw_test.rb", "test/johnson/nodes/try_node_test.rb", "test/johnson/nodes/typeof_test.rb", "test/johnson/nodes/unary_node_test.rb", "test/johnson/nodes/void_test.rb", "test/johnson/nodes/while_test.rb", "test/johnson/nodes/with_test.rb", "test/johnson/prelude_test.rb", "test/johnson/runtime_test.rb", "test/johnson/spidermonkey/context_test.rb", "test/johnson/spidermonkey/immutable_node_test.rb", "test/johnson/spidermonkey/js_land_proxy_test.rb", "test/johnson/spidermonkey/ruby_land_proxy_test.rb", "test/johnson/spidermonkey/runtime_test.rb", "test/johnson/version_test.rb", "test/johnson/visitors/dot_visitor_test.rb", "test/johnson/visitors/enumerating_visitor_test.rb", "test/johnson_test.rb", "test/parser_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<gemcutter>, [">= 0.2.1"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.6"])
      s.add_development_dependency(%q<hoe>, [">= 2.5.0"])
    else
      s.add_dependency(%q<gemcutter>, [">= 0.2.1"])
      s.add_dependency(%q<rake-compiler>, ["~> 0.6"])
      s.add_dependency(%q<hoe>, [">= 2.5.0"])
    end
  else
    s.add_dependency(%q<gemcutter>, [">= 0.2.1"])
    s.add_dependency(%q<rake-compiler>, ["~> 0.6"])
    s.add_dependency(%q<hoe>, [">= 2.5.0"])
  end
end
