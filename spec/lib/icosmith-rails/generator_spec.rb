# -*- coding: utf-8 -*-

require 'spec_helper'

describe Icosmith::Generator do
  describe "#setup_fonts" do
    before do
      Icosmith::Config.should_receive(:load).
        with("path/config/icosmith/icosmith.yml").and_return(config)
    end

    subject do
      Icosmith::Generator.new("path")
    end

    context "without fonts key configured" do
      let(:config) do
        double("config", fonts: nil)
      end

      before do
        Icosmith::Font.should_receive(:new).with("path", config)
      end

      it "returns an array with a single Icosmith::Font instance" do
        subject.setup_fonts.size.should eql 1
      end
    end

    context "with fonts key configured" do
      let(:config) do
        double("config", fonts: %w{font1 font2 font3})
      end

      before do
        Icosmith::Font.should_receive(:new).with("path", config, "font1")
        Icosmith::Font.should_receive(:new).with("path", config, "font2")
        Icosmith::Font.should_receive(:new).with("path", config, "font3")
      end

      it "returns an array with an Icosmith::Font instance for each font" do
        subject.setup_fonts.size.should eql 3
      end
    end
  end
end
