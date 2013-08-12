# -*- coding: utf-8 -*-

module Icosmith
  class Generator
    MANIFEST_FILENAME = "manifest.json"
    SVG_ZIPFILENAME = "svg.zip"
    FONTS_ZIPFILENAME = "fonts.zip"

    def initialize
      config_filename = File.join(Rails.root, "config", "icosmith.yml")
      @config = Icosmith::Config.load(config_filename)

      @manifest_full_path = File.join(@config.manifest_dir, MANIFEST_FILENAME)
      @src_dir = @config.svg_dir

      @temp_dir = File.join(Rails.root, "tmp", "icosmith")
      FileUtils.mkdir_p(@temp_dir)
      @svg_zipfile = File.join(@temp_dir, SVG_ZIPFILENAME)
      @fonts_zipfile = File.join(@temp_dir, FONTS_ZIPFILENAME)
    end

    def create_svg_zipfile
      FileUtils.rm_f(@svg_zipfile)

      Zip::ZipFile.open(@svg_zipfile, Zip::ZipFile::CREATE) do |zipfile|
        Dir.glob("#{@src_dir}/*.svg").each do |filename|
          zipfile.add(filename.split("/").last, filename)
        end

        zipfile.add(MANIFEST_FILENAME, @manifest_full_path) if File.exists?(@manifest_full_path)
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
    def extract_fonts
      Zip::ZipFile.open(@fonts_zipfile) do |zip_file|
        zip_file.each do |file|
          dest_path = File.join(@temp_dir, file.name)
          FileUtils.rm_f(dest_path)
          zip_file.extract(file, dest_path)
        end
      end

      manifest_tempfile = File.join(@temp_dir, MANIFEST_FILENAME)
      manifest_contents = JSON.parse(File.read(manifest_tempfile))
      family_name = manifest_contents["family"].gsub(" ", "")
      weight = manifest_contents["weight"] || "Regular"
      font_basename = "#{family_name}-#{weight}"

      FileUtils.mkdir_p(@config.font_dir)
      FileUtils.mkdir_p(@config.css_dir)
      FileUtils.mv("#{@temp_dir}/#{font_basename}.css", @config.css_dir)
      Dir.glob("#{@temp_dir}/#{font_basename}.{ttf,woff,svg,eot,afm}").each do |file|
        FileUtils.mv(file, @config.font_dir)
      end
      FileUtils.mv(manifest_tempfile, @manifest_full_path)
      FileUtils.remove_dir(@temp_dir)
    end
  end
end
