# -*- coding: utf-8 -*-

module Icosmith
  class Generator
    MANIFEST_FILENAME = "manifest.json"
    TEMP_DIR = Dir.mktmpdir("icosmith")
    SVG_ZIPFILE = "#{TEMP_DIR}/svg.zip"
    FONTS_ZIPFILE = "#{TEMP_DIR}/fonts.zip"

    def config
      src_dir = Icosmith.config.svg_dir
      font_dir = Icosmith.config.font_dir
      css_dir = Icosmith.config.css_dir
      manifest_dir = Icosmith.config.manifest_dir
      icosmith_generate_fonts_url = Icosmith.config.generate_fonts_url
      manifest_full_path = File.join(MANIFEST_DIR, MANIFEST_FILENAME)
    end

    def self.create_svg_zipfile
      FileUtils.rm_f(SVG_ZIPFILE)
      FileUtils.mkdir_p(TEMP_DIR)

      Zip::ZipFile.open(SVG_ZIPFILE, Zip::ZipFile::CREATE) do |zipfile|
        Dir.glob("#{SRC_DIR}/*.svg").each do |filename|
          zipfile.add(filename.split("/").last, filename)
        end

        zipfile.add(MANIFEST_FILENAME, MANIFEST_FULL_PATH) if File.exists?(MANIFEST_FULL_PATH)
      end
    end

    def self.generate_font
      contents = File.read(SVG_ZIPFILE)
      base64 = Base64.encode64 contents
      fontfile_contents = RestClient.post ICOSMITH_GENERATE_FONTS_URL, base64zip: base64

      File.open(FONTS_ZIPFILE, "w") do |f|
        f.write(fontfile_contents)
      end

      extract_fonts
    end

    private
    def self.extract_fonts
      Zip::ZipFile.open(FONTS_ZIPFILE) do |zip_file|
        zip_file.each do |file|
          dest_path = File.join(TEMP_DIR, file.name)
          FileUtils.rm_f(dest_path)
          zip_file.extract(file, dest_path)
        end
      end

      manifest_tempfile = File.join(TEMP_DIR, MANIFEST_FILENAME)
      manifest_contents = JSON.parse(File.read(manifest_tempfile))
      family_name = manifest_contents["family"].gsub(" ", "")
      weight = manifest_contents["weight"] || "Regular"
      font_basename = "#{family_name}-#{weight}"

      FileUtils.mkdir_p(FONT_DIR)
      FileUtils.mkdir_p(CSS_DIR)
      FileUtils.mv("#{TEMP_DIR}/#{font_basename}.css", CSS_DIR)
      Dir.glob("#{TEMP_DIR}/#{font_basename}.{ttf,woff,svg,eot,afm}").each do |file|
        FileUtils.mv(file, FONT_DIR)
      end
      FileUtils.mv(manifest_tempfile, MANIFEST_FULL_PATH)
      FileUtils.remove_dir(TEMP_DIR)
    end
  end
end
