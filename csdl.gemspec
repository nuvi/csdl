# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csdl/version'

Gem::Specification.new do |spec|
  spec.name          = "csdl"
  spec.version       = CSDL::VERSION
  spec.authors       = ["BJ Neilsen", "David Richards"]
  spec.email         = ["bj.neilsen@gmail.com", "davidlamontrichards@gmail.com"]

  spec.summary       = %q{AST Processor and Query Builder for DataSift's CSDL language}
  spec.description   = %q{
CSDL is a gem for producing Abstract Syntax Trees for the [DataSift CSDL Filter Language](http://dev.datasift.com/docs/csdl).
Working with an AST instead of raw strings provides a simpler way to test and validate any given CSDL filter.
}

  spec.requirements  << "You should have Python 3 with Python EDA (https://pyeda.readthedocs.org/en/latest/) installed " \
                        "in order to use the Optimizer"

  spec.homepage      = "https://github.com/localshred/csdl"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) } + %w(
                          lib/csdl/boolean_parser.rb
                          lib/csdl/boolean_lexer.rb
                       )

  spec.require_paths = ["lib"]

  spec.add_dependency "ast", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "cliver", "~> 0.3.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "racc", "= 1.4.14"
  spec.add_development_dependency "yard"
end
