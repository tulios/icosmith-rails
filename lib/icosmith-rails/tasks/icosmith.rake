# -*- coding: utf-8 -*-
require "icosmith-rails"

namespace :icosmith do
  desc "Generates font files with an icosmith server from svg files and organizes in the project"
  task :generate do
    icosmith_fonts.each do |font|
      font.create_svg_zipfile
      font.generate_font
      font.extract_font
    end
  end

  desc "Generates font files with an icosmith server from svg files and stores the package at tmp/icosmith"
  task :download_and_extract do
    icosmith_fonts.each do |font|
      font.create_svg_zipfile
      font.generate_font
    end
  end

  desc "Creates a zip file with a manifest and svg files"
  task :create_svg_zipfile do
    icosmith_fonts.each do |font|
      font.create_svg_zipfile
    end
  end

  private
  def icosmith_fonts
    @fonts ||= Icosmith::Generator.new(root_path).setup_fonts
  end

  def root_path
    defined?(Rails) ? Rails.root : Dir.getwd
  end
end
