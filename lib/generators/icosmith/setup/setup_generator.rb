module Icosmith::Generators

  class SetupGenerator < Rails::Generators::Base
    source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))
    desc "Creates Icosmith configuration files at config/icosmith"

    def create_config_files
      config_dir = "config/icosmith"
      FileUtils.mkdir_p config_dir
      copy_file('icosmith.yml', "#{config_dir}/icosmith.yml")
      copy_file('manifest.json', "#{config_dir}/manifest.json")
      readme "README"
    end
  end

end
