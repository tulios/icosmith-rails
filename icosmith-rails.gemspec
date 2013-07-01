# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'icosmith-rails/version'

Gem::Specification.new do |gem|
  gem.name          = "icosmith-rails"
  gem.version       = Icosmith::VERSION
  gem.authors       = ["tulios", "ggarnier"]
  gem.email         = ["ornelas.tulio@gmail.com", "guilherme.garnier@gmail.com"]
  gem.description   = %q{icosmith-rails gem}
  gem.summary       = %q{icosmith-rails gem}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "rest-client"
  gem.add_dependency "rubyzip"

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "debugger"
end
