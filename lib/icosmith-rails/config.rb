# -*- coding: utf-8 -*-

module Icosmith
  class Config
    FILENAME = "icosmith.yml"
    KEYS = [:svg_dir, :font_dir, :css_dir, :manifest_dir, :generate_fonts_url]

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

  def self.configure
    yield self.config
  end
end
