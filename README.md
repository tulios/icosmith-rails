# icosmith-rails gem

Creates a rake task to generate a new font from svg files

## Installation

Add this line to your application's Gemfile:

    gem 'icosmith-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install icosmith-rails

## Configuration

Add a `config/icosmith.yml` file to your application, like the template on this project. Change the parameters according to your project. `generate_fonts_url` is Icosmith's post URL.

Alternatively, you can configure each parameter individually. Just call `Icosmith.configure` with a block:

    Icosmith.configure do |config|
      config.generate_fonts_url = "http://new-url.com"
    end

## Usage

    rake icosmith:generate

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
