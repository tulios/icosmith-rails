# Icosmith Rails

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
