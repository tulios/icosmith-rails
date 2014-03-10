# -*- coding: utf-8 -*-

module Icosmith
  class Generator
    def initialize(root_path)
      @root_path = root_path
      load_config
    end

    def setup_font
      Icosmith::Font.new(@root_path, @config)
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
