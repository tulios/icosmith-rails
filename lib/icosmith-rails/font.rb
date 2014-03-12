# -*- coding: utf-8 -*-

module Icosmith
  class Font
    SVG_ZIPFILENAME   = "svg.zip"
    FONTS_ZIPFILENAME = "fonts.zip"

    def initialize root_path, config, font_name = ""
      @root_path = root_path
      @config = config
      @font_name = font_name
      setup_parameters
    end

    def create_svg_zipfile
      create_directories
      FileUtils.rm_f(@svg_zipfile)

      log("Compressing SVGs")
      Zip::File.open(@svg_zipfile, Zip::File::CREATE) do |zipfile|
        Dir.glob("#{@src_dir}#{File::SEPARATOR}*.svg").each do |filename|
          zipfile.add(filename.split(File::SEPARATOR).last, filename)
        end

        zipfile.add(Icosmith::MANIFEST_FILENAME, @manifest_full_path) if File.exists?(@manifest_full_path)
      end
    end

    def generate_font
      create_directories

      log("Sending files to #{@config.generate_fonts_url}")
      fontfile_contents = RestClient.post(@config.generate_fonts_url, file: File.new(@svg_zipfile))
      filename = fontfile_contents.headers[:content_disposition].scan(/filename="([^"]+)"/).flatten.first
      filename ||= FONTS_ZIPFILENAME

      @fonts_zipfile = File.join(@temp_dir, filename)

      log("Writing #{filename}")
      File.open(@fonts_zipfile, "w:binary") do |f|
        f.write(fontfile_contents)
      end

      FileUtils.rm_f(@svg_zipfile)
    end

    def extract_font
      create_directories

      log("Replacing files")
      temp_font_path = @fonts_zipfile.gsub(/\.zip$/, '')
      FileUtils.rm_f(temp_font_path)
      FileUtils.mkdir_p(File.join(temp_font_path, "fonts"))
      FileUtils.mkdir_p(@font_dir)
      FileUtils.mkdir_p(@css_dir)

      unzip(@fonts_zipfile, temp_font_path)
      copy_css(temp_font_path)

      Dir.glob("#{temp_font_path}#{File::SEPARATOR}fonts#{File::SEPARATOR}*.{ttf,woff,svg,eot,afm}").each do |file|
        FileUtils.mv(file, @font_dir)
      end

      FileUtils.mv(File.join(temp_font_path, Icosmith::MANIFEST_FILENAME), @manifest_full_path)
      FileUtils.remove_dir(@base_temp_dir)
    end

    private
    def copy_css temp_font_path
      css_path = Dir.glob("#{temp_font_path}#{File::SEPARATOR}*.css").first

      if @config.use_sass
        scss_path = generate_scss(css_path)
        FileUtils.mv(scss_path, @css_dir)
      else
        FileUtils.mv(css_path, @css_dir)
      end
    end

    def generate_scss path
      scss_path = "#{path}.scss"
      log("Generating #{scss_path}")

      css_content = File.read path
      css_content.gsub!(/url\('fonts\//, "font-url('")
      File.open(scss_path, 'w') {|out| out << css_content}
      scss_path
    end

    def unzip path, target
      Zip::File.open(path) do |zip_file|
        zip_file.each do |file|
          zip_file.extract(file, File.join(target, file.name))
        end
      end
    end

    def setup_parameters
      @manifest_full_path = File.join(@root_path, @config.manifest_dir, @font_name, Icosmith::MANIFEST_FILENAME)
      unless File.readable?(@manifest_full_path)
        puts "Error trying to load manifest file at #{@manifest_full_path}"
        exit 1
      end

      @src_dir = File.join(@root_path, @config.svg_dir, @font_name)
      @base_temp_dir = File.join(@root_path, "tmp", "icosmith")
      @temp_dir = File.join(@base_temp_dir, @font_name)
      @svg_zipfile = File.join(@temp_dir, SVG_ZIPFILENAME)
      @css_dir = File.join(@root_path, @config.css_dir)
      @font_dir = File.join(@root_path, @config.font_dir)
    end

    def create_directories
      FileUtils.mkdir_p(@temp_dir)
      FileUtils.mkdir_p(@css_dir)
      FileUtils.mkdir_p(@font_dir)
    end

    def log message, level = :info
      message = "[#{@font_name}] #{message}" unless @font_name.empty?
      Icosmith.logger.send(level, message)
    end
  end
end
