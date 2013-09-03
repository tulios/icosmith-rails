# -*- coding: utf-8 -*-
require "icosmith-rails"

namespace :icosmith do
  desc "Generates font files with an icosmith server from svg files and organizes in the project"
  task generate: [:create_svg_zipfile, :download_and_extract] do
    icosmith_generator.extract_font
  end

  desc "Generates font files with an icosmith server from svg files and stores the package at tmp/icosmith"
  task download_and_extract: [:create_svg_zipfile] do
    icosmith_generator.generate_font
  end

  task :create_svg_zipfile do
    icosmith_generator.create_svg_zipfile
  end

  def icosmith_generator
    @generator ||= Icosmith::Generator.new
  end
end
