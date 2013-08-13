# -*- coding: utf-8 -*-

module Icosmith
  class Generator
    SVG_ZIPFILENAME = "svg.zip"
    FONTS_ZIPFILENAME = "fonts.zip"

    def initialize
      load_config
      setup_parameters
      create_directories
    end

    def create_svg_zipfile
      FileUtils.rm_f(@svg_zipfile)

      Zip::ZipFile.open(@svg_zipfile, Zip::ZipFile::CREATE) do |zipfile|
        Dir.glob("#{@src_dir}#{File::SEPARATOR}*.svg").each do |filename|
          zipfile.add(filename.split(File::SEPARATOR).last, filename)
        end

        zipfile.add(Icosmith::MANIFEST_FILENAME, @manifest_full_path) if File.exists?(@manifest_full_path)
      end
    end

    def generate_font
      fontfile_contents = RestClient.post(@config.generate_fonts_url, file: File.new(@svg_zipfile))

      File.open(@fonts_zipfile, "w:binary") do |f|
        f.write(fontfile_contents)
      end

      extract_fonts
    end

    private
    def load_config
      config_filename = File.join(Rails.root, "config", "icosmith", Icosmith::CONFIG_FILENAME)
      begin
        @config = Icosmith::Config.load(config_filename)
      rescue Exception => e
        puts "Error trying to load icosmith configuration file: #{e.message}"
        exit 1
      end

      @manifest_full_path = File.join(Rails.root, @config.manifest_dir, Icosmith::MANIFEST_FILENAME)
      unless File.readable?(@manifest_full_path)
        puts "Error trying to load manifest file"
        exit 1
      end
    end

    def setup_parameters
      @src_dir = File.join(Rails.root, @config.svg_dir)
      @temp_dir = File.join(Rails.root, "tmp", "icosmith")
      @svg_zipfile = File.join(@temp_dir, SVG_ZIPFILENAME)
      @fonts_zipfile = File.join(@temp_dir, FONTS_ZIPFILENAME)
      @css_dir = File.join(Rails.root, @config.css_dir)
      @font_dir = File.join(Rails.root, @config.font_dir)
    end

    def create_directories
      FileUtils.mkdir_p(@temp_dir)
      FileUtils.mkdir_p(@css_dir)
      FileUtils.mkdir_p(@font_dir)
    end

    def extract_fonts
      Zip::ZipFile.open(@fonts_zipfile) do |zip_file|
        zip_file.each do |file|
          dest_path = File.join(@temp_dir, file.name)
          FileUtils.rm_f(dest_path)
          zip_file.extract(file, dest_path)
        end
      end

      manifest_tempfile = File.join(@temp_dir, Icosmith::MANIFEST_FILENAME)
      manifest_contents = JSON.parse(File.read(manifest_tempfile))
      family_name = manifest_contents["family"].gsub(" ", "")
      weight = manifest_contents["weight"] || "Regular"
      font_basename = "#{family_name}-#{weight}"

      FileUtils.mkdir_p(@font_dir)
      FileUtils.mkdir_p(@css_dir)
      FileUtils.mv("#{@temp_dir}#{File::SEPARATOR}#{font_basename}.css", @css_dir)
      Dir.glob("#{@temp_dir}#{File::SEPARATOR}#{font_basename}.{ttf,woff,svg,eot,afm}").each do |file|
        FileUtils.mv(file, @font_dir)
      end
      FileUtils.mv(manifest_tempfile, @manifest_full_path)
      FileUtils.remove_dir(@temp_dir)
    end
  end
end
