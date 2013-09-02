# icosmith-rails gem

Creates a rake task to generate a new font from svg files using icosmith server

## Installation

Add this line to your application's Gemfile:

    gem 'icosmith-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install icosmith-rails

## Configuration

Create a `config/icosmith` directory in your Rails application. This directory should have 2 files:

   * `manifest.json`. It should contain the font configurations, like the example on this project's root;
   * `icosmith.yml`. Copy the example file from this project's root and change the parameters according to your project. `generate_fonts_url` is Icosmith's post URL.

You can also configure each parameter individually. Just call `Icosmith.configure` with a block:

```ruby
  Icosmith.configure do |config|
    config.generate_fonts_url = "http://new-url.com"
  end
```

## Usage

    rake icosmith:generate

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
