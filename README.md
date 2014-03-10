# Icosmith Rails

Rails integration with an icosmith server.
Creates a rake task to generate a new font from svg files using [icosmith server](https://github.com/tulios/icosmith)

## Installation

Add this line to your application's Gemfile:

    gem 'icosmith-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install icosmith-rails

If you are using Rails, use the setup generator

    $ rails g icosmith:setup

Otherwise create a `config/icosmith` directory and copy `icosmith.yml` and
`manifest.json` from [lib/generators/icosmith/setup/templates](lib/generators/icosmith/setup/templates)

If you aren't using Rails, add this to your `Rakefile`:

```ruby
  begin
    require 'icosmith-rails'
    load 'icosmith-rails/tasks/icosmith.rake'
  rescue LoadError
    task :icosmith do
      abort "Icosmith is not available."
    end
  end
```

## Configuration

`manifest.json`:
  It should contain the font configurations, like the example on [lib/generators/icosmith/setup/templates/manifest.json](lib/generators/icosmith/setup/templates/manifest.json)

`icosmith.yml`:
  Change the parameters according to your project. Take a look at [lib/generators/icosmith/setup/templates/icosmith.yml](lib/generators/icosmith/setup/templates/icosmith.yml). `generate_fonts_url` is Icosmith's post URL.

You can also configure each parameter individually. Just call `Icosmith.configure` with a block:

```ruby
  Icosmith.configure do |config|
    config.generate_fonts_url = "http://new-url.com/generate_font"
  end
```

### Multiple fonts

If you want to use multiple fonts, change the following configurations:

- Edit your `icosmith.yml` file and add a `fonts` parameter, with a list of font names:

```yml
use_sass: true
svg_dir: app/assets/svgs
font_dir: app/assets/fonts
css_dir: app/assets/stylesheets
manifest_dir: config/icosmith
generate_fonts_url: http://icosmith.com/generate_font
fonts:
  - my-font1
  - my-font2
```

- Create a `manifest.json` file for each font, inside a subdirectory with the font name:

```sh
config
└── icosmith
    ├── my-font1
    │   └── manifest.json
    ├── my-font2
    │   └── manifest.json
    └── icosmith.yml
```

- Move each font`s SVG files to a subdirectory with the font name:

```sh
app/svgs/
├── my-font1
│   ├── icon1.svg
│   ├── icon2.svg
│   ├── icon3.svg
│   ├── icon4.svg
└── my-font2
    ├── icon5.svg
    ├── icon6.svg
    └── icon7.svg
```

## Usage

    rake icosmith:generate

If you want to use the example page provided by icosmith, use:

    rake icosmith:download_and_extract

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
