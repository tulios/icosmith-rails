# -*- coding: utf-8 -*-

ENV['RACK_ENV'] = 'test'

$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'rspec'
require 'icosmith-rails'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.color_enabled = true
  config.formatter = :documentation
end
