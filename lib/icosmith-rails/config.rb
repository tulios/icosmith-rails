# -*- coding: utf-8 -*-

module Icosmith
  def config
    @config ||= load!("/tmp/icosmith.yml")
  end

  def load!(path)
    settings = YAML.load(File.read(path))
    OpenStruct.new(settings)
  end
end
