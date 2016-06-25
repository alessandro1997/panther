# Panther

Panther is a lightweight, opinionated architecture for creating API-only Rails
applications.

It is heavily inspired by [Trailblazer](http://trailblazer.to/) but has a
gentler learning curve.

## Installation

Add this line to your application's Gemfile:

```ruby gem 'panther' ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install panther

## Concepts

Panther revolves around four core concepts: the contract, the operation, the
policy and the representer.

### Representer

A representer's job is to render a resource in a specific format. Panther
assumes you'll use JSON, but XML and other formats will work fine.

Representers are nothing more than [Roar](https://github.com/apotonick/roar)
decorators with some assumptions, so you can tweak them as you see fit.

Panther also provides you with mixins for representing collection and pagination
data.

### Contract

Contracts take incoming data, parse it and validate it.

Again, contracts are just [Reform](https://github.com/apotonick/reform) forms.

### Policy

Policies are POROs. They take a contract (or a model, if a contract is not
needed) and a user object as input, and provide a set of predicates to determine
whether the user is authorized to perform the given action on the resource.

They are inspired to [Pundit](https://github.com/elabs/pundit) policies, but
I didn't need any of Pundit's features, so I just reimplemented them from
scratch.

### Operation

Operations glue representers, contracts and policies together to perform tasks
on a certain resource.

Panther provides you with a set of default CRUD operations, but you're free to
write your own.

## Usage

TODO: Write usage instructions

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/alessandro1997/panther.


## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
