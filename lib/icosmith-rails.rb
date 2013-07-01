# -*- coding: utf-8 -*-

require "zip/zip"
require "base64"
require "rest_client"
require "debugger" if ENV["RACK_ENV"] == "test"

module Icosmith
  extend self

  def logger
    Config.logger
  end
end

require "icosmith-rails/version"
require "icosmith-rails/generator"
