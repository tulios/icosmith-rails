# -*- coding: utf-8 -*-

module Icosmith
  class Generator
    def initialize(root_path)
      @root_path = root_path
      load_config
    end

    def setup_fonts
      fonts = []

      if @config.fonts
        @config.fonts.each do |font_name|
          fonts << Icosmith::Font.new(@root_path, @config, font_name)
        end
      else
        fonts << Icosmith::Font.new(@root_path, @config)
      end

      fonts
    end

    private
    def load_config
      config_filename = File.join(@root_path, "config", "icosmith", Icosmith::CONFIG_FILENAME)
      begin
        @config = Icosmith::Config.load(config_filename)
      rescue Exception => e
        puts "Error trying to load icosmith configuration file: #{e.message}"
        exit 1
      end
    end
  end
end
