# -*- coding: utf-8 -*-
require "icosmith-rails"

namespace :icosmith do
  desc "Generates font files from svg files."
  task :generate do
    Icosmith::Generator.create_svg_zipfile
    Icosmith::Generator.generate_font
  end
end
