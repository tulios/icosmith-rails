# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'icosmith-rails/version'

Gem::Specification.new do |gem|
  gem.name          = "icosmith-rails"
  gem.version       = Icosmith::VERSION
  gem.authors       = ["tulios", "Guilherme Garnier"]
  gem.email         = ["ornelas.tulio@gmail.com", "guilherme.garnier@gmail.com"]
  gem.summary       = "Rails integration with an icosmith server"
  gem.description   = "Creates a rake task to generate a new font from svg files using icosmith server"
  gem.homepage      = "https://github.com/tulios/icosmith-rails"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rest-client", "~> 1.6.7"
  gem.add_dependency "rubyzip",     "< 1.0.0"
  gem.add_dependency "thor",        "~> 0.18.1"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "byebug"
  gem.add_development_dependency "fakefs"
end
