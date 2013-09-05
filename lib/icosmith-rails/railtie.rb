# -*- coding: utf-8 -*-
require "icosmith-rails"
require "rails"

module Icosmith
  class Railtie < Rails::Railtie
    railtie_name :icosmith

    rake_tasks do
      load "icosmith-rails/tasks/icosmith.rake"
    end

    initializer "icosmith.load-config" do |app|
      config_file = Rails.root.join("config", "icosmith", Icosmith::CONFIG_FILENAME)
      begin
        Icosmith::Config.load(config_file)
      rescue StandardError => e
        handle_configuration_error(e)
      end
    end

    def handle_configuration_error(e)
      puts "Icosmith is not configured, you need a #{Icosmith::CONFIG_FILENAME} and a #{Icosmith::MANIFEST_FILENAME}"
    end
  end
end
