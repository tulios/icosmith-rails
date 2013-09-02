# -*- coding: utf-8 -*-

module Icosmith
  CONFIG_FILENAME   = "icosmith.yml"
  MANIFEST_FILENAME = "manifest.json"

  class Config
    KEYS = [:svg_dir, :font_dir, :css_dir, :manifest_dir, :generate_fonts_url, :use_sass]

    KEYS.each do |key|
      attr_accessor key
    end

    def self.load(path)
      settings = YAML.load(File.read(path))

      KEYS.each do |key|
        Icosmith.config.send("#{key}=", settings[key.to_s]) if settings.has_key?(key.to_s)
      end

      Icosmith.config
    end
  end

  def self.config
    @@config ||= Config.new
  end

  def self.logger
    @@logger ||= Logger.new(STDOUT).tap do |log|
      log.formatter = lambda {|severity, datetime, progname, msg| " - #{msg}\n"}
    end
  end

  def self.configure
    yield self.config
  end
end
