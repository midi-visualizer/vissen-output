# 🥀 Vissen Output

[![Gem Version](https://badge.fury.io/rb/vissen-output.svg)](https://badge.fury.io/rb/vissen-output)
[![Build Status](https://travis-ci.org/midi-visualizer/vissen-output.svg?branch=master)](https://travis-ci.org/midi-visualizer/vissen-output)
[![Inline docs](http://inch-ci.org/github/midi-visualizer/vissen-output.svg?branch=master)](http://inch-ci.org/github/midi-visualizer/vissen-output)

The Vissen Output library implements the objects used by the Vissen Engine to talk to the various sinks.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vissen-output'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vissen-output

## Usage

```ruby
include Vissen::Output

# First we create a grid shaped context with 64 points.
context = Context::Grid.new 8, 8

# We then create a vixel stack with a single layer.
stack = VixelStack.new context, 1

# We go through each vixel in the layer and randomize its
# palette value (p). We also set the layer palette to
# palette number 1.
stack.layers[0].tap do |layer|
    layer.palette = 1
    layer.each do |vixel|
        vixel.i = 1.0
        vixel.p = rand
    end
end

# Finally we allocate a pixel buffer and render to it.
pixel_buffer = stack.pixel_buffer
stack.render pixel_buffer

```

Please see the [documentation](http://www.rubydoc.info/gems/vissen-output/) for more details.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/midi-visualizer/vissen-output.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
