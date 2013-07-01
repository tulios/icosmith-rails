# -*- coding: utf-8 -*-

# svg: "app/icosmith/svg"
# manifest: "app/icosmith/manifest.json"
# font: "app/assets/fonts"

module Icosmith
  class Generator
    SRC_DIR = "/tmp/svg"
    DEST_DIR = "/tmp/fonts"
    MANIFEST = "#{SRC_DIR}/manifest.json"
    SVG_ZIPFILE = "#{DEST_DIR}/svg.zip"
    FONTS_ZIPFILE = "#{DEST_DIR}/fonts.zip"
    ICOSMITH_GENERATE_FONTS_URL = "http://localhost:3000/generate_font"

    def self.create_svg_zipfile
      FileUtils.rm_f(SVG_ZIPFILE)
      create_manifest

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
    end

    private
    def self.create_manifest
      File.open(MANIFEST, "w") do |f|
        f.write('{"name": "icosmith", "family": "FontSmith Font", "version": "1.0", "copyright": "", "glyphs": []}')
      end
    end
  end
end
