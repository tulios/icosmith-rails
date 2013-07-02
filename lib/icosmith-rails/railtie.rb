# -*- coding: utf-8 -*-
require "icosmith-rails"
require "rails"

module Icosmith
  class Railtie < Rails::Railtie
    railtie_name :icosmith

    rake_tasks do
      load "tasks/icosmith.rake"
    end
  end
end
