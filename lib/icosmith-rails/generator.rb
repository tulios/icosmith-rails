# -*- coding: utf-8 -*-

module Icosmith
  class Generator
    SRC_DIR = "/tmp/svg"
    TEMP_DIR = "/tmp/icosmith"
    FONT_DIR = "/tmp/fonts"
    CSS_DIR = "/tmp/css"
    ICOSMITH_GENERATE_FONTS_URL = "http://localhost:3000/generate_font"

    MANIFEST = "#{SRC_DIR}/manifest.json"
    SVG_ZIPFILE = "#{TEMP_DIR}/svg.zip"
    FONTS_ZIPFILE = "#{TEMP_DIR}/fonts.zip"

    def self.create_svg_zipfile
      FileUtils.rm_f(SVG_ZIPFILE)

      Zip::ZipFile.open(SVG_ZIPFILE, Zip::ZipFile::CREATE) do |zipfile|
        Dir.glob("#{SRC_DIR}/*.svg").each do |filename|
          zipfile.add(filename.split("/").last, filename)
        end

        zipfile.add(MANIFEST.split("/").last, MANIFEST)
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

      manifest = JSON.parse(File.read(File.join(TEMP_DIR, "manifest.json")))
      family_name = manifest["family"].gsub(" ", "")
      weight = manifest["weight"] || "Regular"
      font_basename = "#{family_name}-#{weight}"

      FileUtils.mkdir_p(FONT_DIR)
      FileUtils.mkdir_p(CSS_DIR)
      FileUtils.mv("#{TEMP_DIR}/#{font_basename}.css", CSS_DIR)
      Dir.glob("#{TEMP_DIR}/#{font_basename}.{ttf,woff,svg,eot,afm}").each do |file|
        FileUtils.mv(file, FONT_DIR)
      end
    end
  end
end
