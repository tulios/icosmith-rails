# -*- coding: utf-8 -*-

require 'spec_helper'
require 'tmpdir'
require 'zip'

describe Icosmith::Font do
  let!(:root_path) do
    Dir.mktmpdir
  end

  before do
    Icosmith.logger.stub(:info)
  end

  after do
    FileUtils.rm_rf(root_path)
  end

  describe "#create_svg_zipfile" do
    before do
      FileUtils.mkdir_p("#{root_path}/manifest/my-font")
      FileUtils.touch("#{root_path}/manifest/my-font/manifest.json")

      FileUtils.mkdir_p("#{root_path}/svgs/my-font")
      FileUtils.touch("#{root_path}/svgs/my-font/icon1.svg")
      FileUtils.touch("#{root_path}/svgs/my-font/icon2.svg")
    end

    subject do
      Icosmith::Font.new(root_path, config, "my-font")
    end

    let(:config) do
      double("config", manifest_dir: "manifest", svg_dir: "svgs", css_dir: "stylesheets", font_dir: "fonts")
    end

    it "creates a zip file with the font .svg files and manifest.json" do
      subject.create_svg_zipfile

      Zip::File.open("#{root_path}/tmp/icosmith/my-font/svg.zip") do |zip_file|
        zip_file.map(&:name).should eql %w{icon1.svg icon2.svg manifest.json}
      end
    end
  end

  describe "#generate_font" do
    subject do
      Icosmith::Font.new(root_path, config, "my-font")
    end

    let(:config) do
      double("config", generate_fonts_url: "/url", manifest_dir: "manifest", svg_dir: "svgs", css_dir: "stylesheets", font_dir: "fonts")
    end

    let(:fontfile_contents) do
      double("font", headers: {content_disposition: 'filename="file.zip"'})
    end

    before do
      FileUtils.mkdir_p("#{root_path}/manifest/my-font")
      FileUtils.touch("#{root_path}/manifest/my-font/manifest.json")

      file = double("svg.zip")
      File.stub(:new).and_return(file)
      RestClient.stub(:post).with("/url", file: file).and_return(fontfile_contents)

      subject.generate_font
    end

    it "saves the server response to a local file" do
      fontfile = "#{root_path}/tmp/icosmith/my-font/file.zip"
      File.read(fontfile).should eql fontfile_contents.to_s
    end

    it "removes the svg zip file" do
      File.exists?("#{root_path}/tmp/icosmith/my-font/svg.zip").should be_false
    end
  end

  describe "#extract_font" do
    subject do
      Icosmith::Font.new(root_path, config, "my-font")
    end

    let(:config) do
      double("config", use_sass: false, manifest_dir: "manifest", svg_dir: "svgs", css_dir: "stylesheets", font_dir: "fonts")
    end

    before do
      FileUtils.mkdir_p("#{root_path}/manifest/my-font")
      FileUtils.touch("#{root_path}/manifest/my-font/manifest.json")

      fontfile = "#{root_path}/tmp/icosmith/my-font/file.zip"
      subject.instance_variable_set(:@fonts_zipfile, fontfile)
      FileUtils.mkdir_p("#{root_path}/tmp/icosmith/my-font/fonts")

      fontfiles = []
      %w{ttf woff svg eot afm}.each do |extension|
        fontfiles << "#{root_path}/tmp/icosmith/my-font/fonts/my-font.#{extension}"
      end
      otherfiles = []
      otherfiles << "#{root_path}/tmp/icosmith/my-font/manifest.json"
      otherfiles << "#{root_path}/tmp/icosmith/my-font/my-font.css"
      Zip::File.open("#{root_path}/tmp/icosmith/my-font/file.zip", Zip::File::CREATE) do |zipfile|
        fontfiles.each do |filename|
          FileUtils.touch(filename)
          zipfile.add("fonts/"+filename.split(File::SEPARATOR).last, filename)
        end

        otherfiles.each do |filename|
          FileUtils.touch(filename)
          zipfile.add(filename.split(File::SEPARATOR).last, filename)
        end
      end

      subject.extract_font
    end

    it "moves css file to css_dir" do
      File.exists?("#{root_path}/stylesheets/my-font.css").should be_true
    end

    it "moves font files to font_dir" do
      %w{ttf woff svg eot afm}.each do |extension|
        File.exists?("#{root_path}/fonts/my-font.#{extension}").should be_true
      end
    end

    it "moves manifest.json file to manifest_dir" do
      File.exists?("#{root_path}/manifest/my-font/manifest.json").should be_true
    end
  end
end
