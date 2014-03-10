# -*- coding: utf-8 -*-
require "icosmith-rails"

namespace :icosmith do
  desc "Generates font files with an icosmith server from svg files and organizes in the project"
  task generate: [:create_svg_zipfile, :download_and_extract] do
    icosmith_font.extract_font
  end

  desc "Generates font files with an icosmith server from svg files and stores the package at tmp/icosmith"
  task download_and_extract: [:create_svg_zipfile] do
    icosmith_font.generate_font
  end

  task :create_svg_zipfile do
    icosmith_font.create_svg_zipfile
  end

  private
  def icosmith_font
    @font ||= Icosmith::Generator.new(root_path).setup_font
  end

  def root_path
    defined?(Rails) ? Rails.root : Dir.getwd
  end
end
