# -*- coding: utf-8 -*-
require "icosmith-rails"
require "rails"

module Icosmith
  class Railtie < Rails::Railtie
    railtie_name :icosmith

    rake_tasks do
      load "tasks/icosmith.rake"
    end

    initializer "icosmith.load-config" do |app|
      config_file = Rails.root.join("config", "icosmith.yml")
      begin
        Icosmith::Config.load(config_file)
      rescue Exception => e
        handle_configuration_error(e)
      end
    end

    def handle_configuration_error(e)
      puts "There is a configuration error with the current icosmith.yml."
      puts e.inspect
      puts e.message
    end
  end
end
