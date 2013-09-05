# -*- coding: utf-8 -*-

require "zip/zip"
require "rest_client"
require "json"
require "logger"
require "byebug" if ENV["RACK_ENV"] == "test"

module Icosmith
  extend self

  def logger
    Config.logger
  end
end

require "icosmith-rails/version"
require "icosmith-rails/config"
require "icosmith-rails/generator"
require "icosmith-rails/railtie" if defined?(Rails)
