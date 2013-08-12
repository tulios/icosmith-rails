# -*- coding: utf-8 -*-
require "icosmith-rails"

namespace :icosmith do
  desc "Generates font files from svg files"
  task :generate do
    generator = Icosmith::Generator.new
    generator.create_svg_zipfile
    generator.generate_font
  end
end
