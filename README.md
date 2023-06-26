# aksarantara.rb

[![Gem Version](https://badge.fury.io/rb/aksarantara.svg)](https://badge.fury.io/rb/aksarantara)
[![Build Status](https://travis-ci.org/ubcsanskrit/aksarantara.rb.svg?branch=master)](https://travis-ci.org/ubcsanskrit/aksarantara.rb)
[![Coverage Status](https://coveralls.io/repos/github/ubcsanskrit/aksarantara.rb/badge.svg?branch=master)](https://coveralls.io/github/ubcsanskrit/aksarantara.rb?branch=master)
[![Inline docs](http://inch-ci.org/github/ubcsanskrit/aksarantara.rb.svg?branch=master)](http://inch-ci.org/github/ubcsanskrit/aksarantara.rb)

This gem is starting off as a mostly-straightforward port of [learnsanskrit.org's aksarantara.js](https://github.com/sanskrit/aksarantara.js), and will go from there. It also incorporates transliteration scheme detection based on [learnsanskrit.org's Detect.js](https://github.com/sanskrit/detect.js).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aksarantara'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aksarantara

## Usage

You can access detection through `aksarantara.detect(text)` and transliteration through `aksarantara.transliterate(text, from, to)`.

Documentation is provided in YARD format and available online at [rubydoc.info](http://www.rubydoc.info/github/ubcsanskrit/aksarantara.rb).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ubcsanskrit/aksarantara. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
