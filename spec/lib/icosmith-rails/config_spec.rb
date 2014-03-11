# -*- coding: utf-8 -*-

require 'spec_helper'
require 'fakefs/spec_helpers'

describe Icosmith::Config do
  subject do
    Icosmith::Config.new
  end

  describe "accessors for keys" do
    [:svg_dir, :font_dir, :fonts, :css_dir, :manifest_dir, :generate_fonts_url, :use_sass].each do |key|
      it "creates an acessor for #{key} key" do
        subject.should respond_to(key)
      end
    end
  end

  describe ".load" do
    include FakeFS::SpecHelpers

    before do
      File.write("config.yml", "css_dir: path/to/css\nuse_sass: true")
    end

    it "sets the configuration values from a file" do
      config = Icosmith::Config.load("config.yml")

      config.css_dir.should eql "path/to/css"
      config.use_sass.should be_true
    end
  end
end

describe Icosmith do
  describe ".config" do
    it "returns a new instance of Icosmith::Config" do
      Icosmith.config.should be_an_instance_of Icosmith::Config
    end
  end

  describe ".logger" do
    it "returns a logger with a configured formatter" do
      logger = Icosmith.logger
      logger_message = logger.formatter.call(:error, Time.now, nil, "error message")
      logger_message.should eql " - error message\n"
    end
  end

  describe ".configure" do
    it "yields a configuration block to config method" do
      expect do |block|
        Icosmith.configure(&block)
      end.to yield_with_args(Icosmith.config)
    end
  end
end
